// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gherkin_suite_test.dart';

// **************************************************************************
// GherkinSuiteTestGenerator
// **************************************************************************

class _CustomGherkinIntegrationTestRunner extends GherkinIntegrationTestRunner {
  _CustomGherkinIntegrationTestRunner({
    required FlutterTestConfiguration configuration,
    required StartAppFn appMainFunction,
    required Timeout scenarioExecutionTimeout,
    AppLifecyclePumpHandlerFn? appLifecyclePumpHandler,
  }) : super(
          configuration: configuration,
          appMainFunction: appMainFunction,
          scenarioExecutionTimeout: scenarioExecutionTimeout,
          appLifecyclePumpHandler: appLifecyclePumpHandler,
        );

  @override
  void onRun() {
    testFeature0();
    testFeature1();
    testFeature2();
  }

  void testFeature0() {
    runFeature(
      name: 'Creating todos:',
      tags: <String>['@tag'],
      run: () {
        runScenario(
          name: 'User can create single todo item',
          path: '.\\integration_test\\features\\create.feature',
          tags: <String>['@tag'],
          steps: [
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Given I fill the "todo" field with "Buy spinach"',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'When I tap the "add" button',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Then I expect the todo list',
                multiLineStrings: <String>[],
                table: GherkinTable.fromJson('[{"Todo":"Buy spinach"}]'),
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'When I take a screenshot called \'Johnson\'',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
          ],
          onBefore: () async => onBeforeRunFeature(
            name: 'Creating todos',
            path: r'.\\integration_test\\features\\create.feature',
            tags: <String>['@tag'],
          ),
        );

        runScenario(
          name: 'User can create multiple new todo items',
          path: '.\\integration_test\\features\\create.feature',
          tags: <String>['@tag'],
          steps: [
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Given I fill the "todo" field with "Buy carrots"',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'When I tap the "add" button',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'And I fill the "todo" field with "Buy hannah\'s apples"',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'When I tap the "add" button',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'And I fill the "todo" field with "Buy blueberries"',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'When I tap the "add" button',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Then I expect the todo list',
                multiLineStrings: <String>[],
                table: GherkinTable.fromJson(
                    '[{"Todo":"Buy blueberries"},{"Todo":"Buy hannah\'s apples"},{"Todo":"Buy carrots"}]'),
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Given I wait 5 seconds for the animation to complete',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Given I have item with data',
                multiLineStrings: <String>[
                  """{
  "glossary": {
    "title": "example glossary",
    "GlossDiv": {
      "title": "S",
      "GlossList": {
        "GlossEntry": {
          "ID": "SGML",
          "SortAs": "SGML",
          "GlossTerm": "Standard Generalized Markup Language",
          "Acronym": "SGML",
          "Abbrev": "ISO 8879:1986",
          "GlossDef": {
            "para": "A meta-markup language, used to create markup languages such as DocBook.",
            "GlossSeeAlso": [
              "GML",
              "XML"
            ]
          },
          "GlossSee": "markup"
        }
      }
    }
  }
}"""
                ],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
          ],
          onAfter: () async => onAfterRunFeature(
            name: 'Creating todos',
            path: r'.\\integration_test\\features\\create.feature',
            tags: <String>['@tag'],
          ),
        );
      },
    );
  }

  void testFeature1() {
    runFeature(
      name: 'Swiping:',
      tags: <String>['@tag'],
      run: () {
        runScenario(
          name: 'User can swipe cards left and right',
          path: '.\\integration_test\\features\\swiping.feature',
          tags: <String>['@tag', '@debug'],
          steps: [
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name:
                    'Given I swipe right by 250 pixels on the "scrollable cards"`',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Then I expect the text "Page 2" to be present',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name:
                    'Given I swipe left by 250 pixels on the "scrollable cards"`',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Then I expect the text "Page 1" to be present',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
          ],
          onBefore: () async => onBeforeRunFeature(
            name: 'Swiping',
            path: r'.\\integration_test\\features\\swiping.feature',
            tags: <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature(
            name: 'Swiping',
            path: r'.\\integration_test\\features\\swiping.feature',
            tags: <String>['@tag'],
          ),
        );
      },
    );
  }

  void testFeature2() {
    runFeature(
      name: 'Checking data:',
      tags: <String>['@tag'],
      run: () {
        runScenario(
          name: 'User can have data',
          path: '.\\integration_test\\features\\check.feature',
          tags: <String>['@tag', '@tag1'],
          steps: [
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Given I have item with data',
                multiLineStrings: <String>[
                  """{
  "glossary": {
    "title": "example glossary",
    "GlossDiv": {
      "title": "S",
      "GlossList": {
        "GlossEntry": {
          "ID": "SGML",
          "SortAs": "SGML",
          "GlossTerm": "Standard Generalized Markup Language",
          "Acronym": "SGML",
          "Abbrev": "ISO 8879:1986",
          "GlossDef": {
            "para": "A meta-markup language, used to create markup languages such as DocBook.",
            "GlossSeeAlso": [
              "GML",
              "XML"
            ]
          },
          "GlossSee": "markup"
        }
      }
    }
  }
}"""
                ],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
          ],
          onBefore: () async => onBeforeRunFeature(
            name: 'Checking data',
            path: r'.\\integration_test\\features\\check.feature',
            tags: <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature(
            name: 'Checking data',
            path: r'.\\integration_test\\features\\check.feature',
            tags: <String>['@tag'],
          ),
        );
      },
    );
  }
}

void executeTestSuite({
  required FlutterTestConfiguration configuration,
  required StartAppFn appMainFunction,
  Timeout scenarioExecutionTimeout = const Timeout(Duration(minutes: 10)),
  AppLifecyclePumpHandlerFn? appLifecyclePumpHandler,
}) {
  _CustomGherkinIntegrationTestRunner(
    configuration: configuration,
    appMainFunction: appMainFunction,
    appLifecyclePumpHandler: appLifecyclePumpHandler,
    scenarioExecutionTimeout: scenarioExecutionTimeout,
  ).run();
}
