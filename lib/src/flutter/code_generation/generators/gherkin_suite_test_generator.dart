import 'dart:io';

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_gherkin/src/flutter/code_generation/annotations/gherkin_full_test_suite_annotation.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

class NoOpReporter extends Reporter {}

class GherkinSuiteTestGenerator
    extends GeneratorForAnnotation<GherkinTestSuite> {
  static const String TEMPLATE = '''
class _CustomGherkinIntegrationTestRunner extends GherkinIntegrationTestRunner {
  _CustomGherkinIntegrationTestRunner(
    TestConfiguration configuration,
    void Function() appMainFunction,
  ) : super(configuration, appMainFunction);

  @override
  void onRun() {
    {{features_to_execute}}
  }

  {{feature_functions}}
}

void executeTestSuite(
  TestConfiguration configuration,
  void Function() appMainFunction,
) {
  _CustomGherkinIntegrationTestRunner(configuration, appMainFunction).run();
}
''';
  final _reporter = NoOpReporter();
  final _languageService = LanguageService();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    _languageService.initialise(
      annotation.read('featureDefaultLanguage').literalValue.toString(),
    );
    final executionOrder = ExecutionOrder.values[annotation
        .read('executionOrder')
        .objectValue
        .getField('index')
        .toIntValue()];
    final featureFiles = annotation
        .read('featurePaths')
        .listValue
        .map((path) => Glob(path.toStringValue()))
        .map(
          (glob) => glob
              .listSync()
              .map((entity) => File(entity.path).readAsStringSync())
              .toList(),
        )
        .reduce((value, element) => value..addAll(element));

    if (executionOrder == ExecutionOrder.random) {
      featureFiles..shuffle();
    }

    final featureExecutionFunctionsBuilder = StringBuffer();
    final generator = FeatureFileTestGenerator();
    var id = 0;

    for (var featureFileContent in featureFiles) {
      final code = await generator.generate(
        id++,
        featureFileContent,
        '',
        _languageService,
        _reporter,
      );
      featureExecutionFunctionsBuilder.writeln(code);
    }

    return TEMPLATE
        .replaceAll('{{feature_functions}}',
            featureExecutionFunctionsBuilder.toString())
        .replaceAll(
          '{{features_to_execute}}',
          List.generate(
            id,
            (index) => 'testFeature$index();',
            growable: false,
          ).join('\n'),
        );
  }
}

class FeatureFileTestGenerator {
  Future<String> generate(
    int id,
    String featureFileContents,
    String path,
    LanguageService languageService,
    Reporter reporter,
  ) async {
    final visitor = FeatureFileTestGeneratorVisitor();

    return await visitor.generateTests(
      id,
      featureFileContents,
      path,
      languageService,
      reporter,
    );
  }
}

class FeatureFileTestGeneratorVisitor extends FeatureFileVisitor {
  static const String FUNCTION_TEMPLATE = '''
  void testFeature{{feature_number}}() {
    runFeature(
      '{{feature_name}}:',
      {{tags}},
      () async {
        {{scenarios}}
      },
    );
  }
  ''';
  static const String SCENARIO_TEMPLATE = '''
  runScenario(
    '{{scenario_name}}',
    {{tags}},
    (TestDependencies dependencies) async {
      {{steps}}
    },
  );
  ''';
  static const String STEP_TEMPLATE = '''
  await runStep(
    '{{step_name}}',
    {{step_multi_line_strings}},
    {{step_table}},
    dependencies,
  );
  ''';

  final StringBuffer _buffer = StringBuffer();
  int _id;
  String _currentFeatureCode;
  String _currentScenarioCode;
  final StringBuffer _scenarioBuffer = StringBuffer();
  final StringBuffer _stepBuffer = StringBuffer();

  Future<String> generateTests(
    int id,
    String featureFileContents,
    String path,
    LanguageService languageService,
    Reporter reporter,
  ) async {
    _id = id;
    await visit(
      featureFileContents,
      path,
      languageService,
      reporter,
    );

    _flushScenario();
    _flushFeature();

    return _buffer.toString();
  }

  @override
  Future<void> visitFeature(
    String name,
    String description,
    Iterable<String> tags,
  ) async {
    _currentFeatureCode =
        _replaceVariable(FUNCTION_TEMPLATE, 'feature_number', _id.toString());
    _currentFeatureCode =
        _replaceVariable(_currentFeatureCode, 'feature_name', name);
    _currentFeatureCode = _replaceVariable(
      _currentFeatureCode,
      'tags',
      '[${tags.map((e) => "'$e'").join(', ')}]',
    );
  }

  @override
  Future<void> visitScenario(String name, Iterable<String> tags) async {
    _flushScenario();
    _currentScenarioCode =
        _replaceVariable(SCENARIO_TEMPLATE, 'scenario_name', name);
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode,
      'tags',
      '[${tags.map((e) => "'$e'").join(', ')}]',
    );
  }

  @override
  Future<void> visitScenarioStep(
    String name,
    Iterable<String> multiLineStrings,
    Table table,
  ) async {
    var code = _replaceVariable(STEP_TEMPLATE, 'step_name', name);
    code = _replaceVariable(
      code,
      'step_multi_line_strings',
      '[${multiLineStrings.map((s) => "'$s'").join(',')}]',
    );
    code = _replaceVariable(
      code,
      'step_table',
      table == null ? 'null' : 'Table.fromJson(\'${table.toJson()}\')',
    );

    _stepBuffer.writeln(code);
  }

  void _flushFeature() {
    if (_currentFeatureCode != null) {
      _currentFeatureCode = _replaceVariable(
        _currentFeatureCode,
        'scenarios',
        _scenarioBuffer.toString(),
      );

      _buffer.writeln(_currentFeatureCode);
    }

    _currentFeatureCode = null;
    _scenarioBuffer.clear();
  }

  void _flushScenario() {
    if (_currentScenarioCode != null) {
      if (_stepBuffer.isNotEmpty) {
        _currentScenarioCode = _replaceVariable(
          _currentScenarioCode,
          'steps',
          _stepBuffer.toString(),
        );
      }

      _scenarioBuffer.writeln(_currentScenarioCode);
    }

    _currentScenarioCode = null;
    _stepBuffer.clear();
  }

  String _replaceVariable(String content, String property, String value) {
    return content.replaceAll('{{$property}}', value);
  }
}
