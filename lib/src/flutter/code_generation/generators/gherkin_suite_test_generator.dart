import 'dart:io';

// ignore: implementation_imports
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_gherkin/src/flutter/code_generation/annotations/gherkin_full_test_suite_annotation.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:source_gen/source_gen.dart';

class NoOpReporter extends MessageReporter {
  @override
  Future<void> message(String message, MessageLevel level) async {
    if (level == MessageLevel.info || level == MessageLevel.debug) {
      // ignore: avoid_print
      print(message);
    } else if (level == MessageLevel.warning) {
      // ignore: avoid_print
      print('\x1B[33m$message\x1B[0m');
    } else if (level == MessageLevel.error) {
      // ignore: avoid_print
      print('\x1B[31m$message\x1B[0m');
    }
  }
}

class GherkinSuiteTestGenerator
    extends GeneratorForAnnotation<GherkinTestSuite> {
  static const String template = '''
class _CustomGherkinIntegrationTestRunner extends GherkinIntegrationTestRunner {
  _CustomGherkinIntegrationTestRunner({
    required FlutterTestConfiguration configuration,
    required StartAppFn appMainFunction,
    required Timeout scenarioExecutionTimeout,
    AppLifecyclePumpHandlerFn? appLifecyclePumpHandler,
    LiveTestWidgetsFlutterBindingFramePolicy? framePolicy,
  }) : super(
          configuration: configuration,
          appMainFunction: appMainFunction,
          scenarioExecutionTimeout: scenarioExecutionTimeout,
          appLifecyclePumpHandler: appLifecyclePumpHandler,
          framePolicy: framePolicy,
        );

  @override
  void onRun() {
    {{features_to_execute}}
  }

  {{feature_functions}}
}

Future<void> executeTestSuite({
  required FlutterTestConfiguration configuration,
  required StartAppFn appMainFunction,
  Timeout scenarioExecutionTimeout = const Timeout(const Duration(minutes: 10)),
  AppLifecyclePumpHandlerFn? appLifecyclePumpHandler,
  LiveTestWidgetsFlutterBindingFramePolicy? framePolicy,
}) =>
    _CustomGherkinIntegrationTestRunner(
      configuration: configuration,
      appMainFunction: appMainFunction,
      appLifecyclePumpHandler: appLifecyclePumpHandler,
      scenarioExecutionTimeout: scenarioExecutionTimeout,
      framePolicy: framePolicy,
    ).run();
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
    final idx = annotation
        .read('executionOrder')
        .objectValue
        .getField('index')!
        .toIntValue()!;
    final executionOrder = ExecutionOrder.values[idx];
    final featureFiles = annotation
        .read('featurePaths')
        .listValue
        .map((path) => Glob(path.toStringValue()!))
        .map((glob) =>
            glob.listSync().map((entity) => File(entity.path)).toList())
        .reduce((value, element) => value..addAll(element));
    final useAbsolutePaths =
        annotation.read('useAbsolutePaths').objectValue.toBoolValue();

    if (executionOrder == ExecutionOrder.random) {
      featureFiles.shuffle();
    }

    final featureExecutionFunctionsBuilder = StringBuffer();
    final generator = FeatureFileTestGenerator();
    final featuresToExecute = StringBuffer();
    var id = 0;

    for (var featureFile in featureFiles) {
      final code = await generator.generate(
        id++,
        await featureFile.readAsString(),
        useAbsolutePaths ?? true ? featureFile.absolute.path : featureFile.path,
        _languageService,
        _reporter,
      );

      if (code.isNotEmpty) {
        featuresToExecute.writeln('testFeature${id - 1}();');
        featureExecutionFunctionsBuilder.writeln(code);
      }
    }

    return template
        .replaceAll('{{feature_functions}}',
            featureExecutionFunctionsBuilder.toString())
        .replaceAll(
          '{{features_to_execute}}',
          featuresToExecute.toString(),
        );
  }
}

class FeatureFileTestGenerator {
  Future<String> generate(
    int id,
    String featureFileContents,
    String path,
    LanguageService languageService,
    MessageReporter reporter,
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
  static const String functionTemplate = '''
  void testFeature{{feature_number}}() {
    runFeature(
      name: '{{feature_name}}:',
      tags: {{tags}},
      run: () {
        {{scenarios}}
      },
    );
  }
  ''';
  static const String scenarioTemplate = '''
  runScenario(
    name: '{{scenario_name}}',
    description: {{scenario_description}},
    path: '{{path}}',
    tags:{{tags}},
    steps: [{{steps}},],
    {{onBefore}}
    {{onAfter}}
  );
  ''';
  static const String stepTemplate = '''
(TestDependencies dependencies, bool skip,) async {
  return runStep(
    name: '{{step_name}}',
    multiLineStrings: {{step_multi_line_strings}},
    table: {{step_table}},
    dependencies: dependencies,
    skip: skip,
  );}
  ''';
  static const String onBeforeScenarioRun = '''
  onBefore: () async => onBeforeRunFeature(
    name:'{{feature_name}}', 
    path:'{{path}}', 
    description: {{feature_description}}, 
    tags:{{feature_tags}},),
  ''';
  static const String onAfterScenarioRun = '''
  onAfter: () async => onAfterRunFeature(
    name:'{{feature_name}}', 
    path:'{{path}}', 
    description: {{feature_description}}, 
    tags:{{feature_tags}},),
  ''';

  final StringBuffer _buffer = StringBuffer();
  int? _id;
  String? _currentFeatureCode;
  String? _currentScenarioCode;
  final StringBuffer _scenarioBuffer = StringBuffer();
  final StringBuffer _stepBuffer = StringBuffer();
  final _steps = [];

  Future<String> generateTests(
    int id,
    String featureFileContents,
    String path,
    LanguageService languageService,
    MessageReporter reporter,
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
    String? description,
    Iterable<String> tags,
    int childScenarioCount,
  ) async {
    if (childScenarioCount > 0) {
      _currentFeatureCode = _replaceVariable(
        functionTemplate,
        'feature_number',
        _id.toString(),
      );
      _currentFeatureCode = _replaceVariable(
        _currentFeatureCode!,
        'feature_name',
        _escapeText(name),
      );
      _currentFeatureCode = _replaceVariable(
        _currentFeatureCode!,
        'tags',
        '<String>[${tags.map((e) => "'$e'").join(', ')}]',
      );
    }
  }

  @override
  Future<void> visitScenario(
    String featureName,
    String? featureDescription,
    Iterable<String> featureTags,
    String name,
    String? description,
    Iterable<String> tags,
    String path, {
    required bool isFirst,
    required bool isLast,
  }) async {
    _flushScenario();
    _currentScenarioCode = _replaceVariable(
      scenarioTemplate,
      'onBefore',
      isFirst ? onBeforeScenarioRun : '',
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'onAfter',
      isLast ? onAfterScenarioRun : '',
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'feature_name',
      _escapeText(featureName),
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'feature_description',
      _escapeText(
        featureDescription == null ? null : '"""$featureDescription"""',
      ),
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'path',
      _escapeText(path),
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'feature_tags',
      '<String>[${featureTags.map((e) => "'$e'").join(', ')}]',
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'scenario_name',
      _escapeText(name),
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'scenario_description',
      _escapeText(description == null ? null : '"$description"'),
    );
    _currentScenarioCode = _replaceVariable(
      _currentScenarioCode!,
      'tags',
      '<String>[${tags.map((e) => "'$e'").join(', ')}]',
    );
  }

  @override
  Future<void> visitScenarioStep(
    String name,
    Iterable<String> multiLineStrings,
    GherkinTable? table,
  ) async {
    var code = _replaceVariable(
      stepTemplate,
      'step_name',
      _escapeText(name),
    );
    code = _replaceVariable(
      code,
      'step_multi_line_strings',
      '<String>[${multiLineStrings.map((s) => '"""$s"""').join(',')}]',
    );
    code = _replaceVariable(
      code,
      'step_table',
      table == null
          ? 'null'
          : 'GherkinTable.fromJson(\'${_escapeText(table.toJson())}\')',
    );

    _stepBuffer.writeln(code);
    _steps.add(code);
  }

  void _flushFeature() {
    if (_currentFeatureCode != null) {
      _currentFeatureCode = _replaceVariable(
        _currentFeatureCode!,
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
      if (_steps.isNotEmpty) {
        _currentScenarioCode = _replaceVariable(
          _currentScenarioCode!,
          'steps',
          _steps.join(','),
        );

        _steps.clear();
      }

      _scenarioBuffer.writeln(_currentScenarioCode);
    }

    _currentScenarioCode = null;
    _stepBuffer.clear();
  }

  String _replaceVariable(String content, String property, String? value) {
    return content.replaceAll('{{$property}}', value ?? 'null');
  }

  String? _escapeText(String? text) => text
      ?.replaceAll("\\", "\\\\")
      .replaceAll("'", "\\'")
      .replaceAll(r"$", r"\$");
}
