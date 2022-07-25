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
    testFeature0();
    testFeature1();
    testFeature2();
    testFeature3();
    testFeature4();
  }

  void testFeature0() {
    runFeature(
      name: 'Creating todos:',
      tags: <String>['@tag'],
      run: () {
        runScenario(
          name: 'User can create single todo item',
          description: null,
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
            path: '.\\integration_test\\features\\create.feature',
            description: null,
            tags: <String>['@tag'],
          ),
        );

        runScenario(
          name: 'User can create multiple new todo items',
          description: null,
          path: '.\\integration_test\\features\\create.feature',
          tags: <String>['@tag', '@debug2'],
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
            path: '.\\integration_test\\features\\create.feature',
            description: null,
            tags: <String>['@tag'],
          ),
        );
      },
    );
  }

  void testFeature1() {
    runFeature(
      name: 'Checking data:',
      tags: <String>['@tag'],
      run: () {
        runScenario(
          name: 'User can have data',
          description: null,
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
            path: '.\\integration_test\\features\\check.feature',
            description: null,
            tags: <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature(
            name: 'Checking data',
            path: '.\\integration_test\\features\\check.feature',
            description: null,
            tags: <String>['@tag'],
          ),
        );
      },
    );
  }

  void testFeature2() {
    runFeature(
      name: 'Swiping:',
      tags: <String>['@tag'],
      run: () {
        runScenario(
          name: 'User can swipe cards left and right',
          description: null,
          path: '.\\integration_test\\features\\swiping.feature',
          tags: <String>['@tag'],
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
            path: '.\\integration_test\\features\\swiping.feature',
            description: null,
            tags: <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature(
            name: 'Swiping',
            path: '.\\integration_test\\features\\swiping.feature',
            description: null,
            tags: <String>['@tag'],
          ),
        );
      },
    );
  }

  void testFeature3() {
    runFeature(
      name: 'Parsing:',
      tags: <String>['@debug'],
      run: () {
        runScenario(
          name: 'Parsing a',
          description: null,
          path: '.\\integration_test\\features\\parsing.feature',
          tags: <String>['@debug'],
          steps: [
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name: 'Given the text "^[A-Z]{3}\\\\d{5}\\\$"',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
          ],
          onBefore: () async => onBeforeRunFeature(
            name: 'Parsing',
            path: '.\\integration_test\\features\\parsing.feature',
            description: """Complex description:
- Line "one".
- Line two, more text
- Line three""",
            tags: <String>['@debug'],
          ),
          onAfter: () async => onAfterRunFeature(
            name: 'Parsing',
            path: '.\\integration_test\\features\\parsing.feature',
            description: """Complex description:
- Line "one".
- Line two, more text
- Line three""",
            tags: <String>['@debug'],
          ),
        );
      },
    );
  }

  void testFeature4() {
    runFeature(
      name: 'Expect failures:',
      tags: <String>[],
      run: () {
        runScenario(
          name: 'Exception should be added to json report',
          description: null,
          path: '.\\integration_test\\features\\failure.feature',
          tags: <String>['@failure-expected'],
          steps: [
            (
              TestDependencies dependencies,
              bool skip,
            ) async {
              return await runStep(
                name:
                    'When I tap the "button is not here but exception should be logged in report" button',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
          ],
          onBefore: () async => onBeforeRunFeature(
            name: 'Expect failures',
            path: '.\\integration_test\\features\\failure.feature',
            description:
                """Ensure that when a test fails the exception or test failure is reported""",
            tags: <String>[],
          ),
        );

        runScenario(
          name: 'Failed expect() should be added to json report',
          description: "Description for this scenario!",
          path: '.\\integration_test\\features\\failure.feature',
          tags: <String>['@failure-expected'],
          steps: [
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
                name: 'Then I expect a failure',
                multiLineStrings: <String>[],
                table: null,
                dependencies: dependencies,
                skip: skip,
              );
            },
          ],
          onAfter: () async => onAfterRunFeature(
            name: 'Expect failures',
            path: '.\\integration_test\\features\\failure.feature',
            description:
                """Ensure that when a test fails the exception or test failure is reported""",
            tags: <String>[],
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
  LiveTestWidgetsFlutterBindingFramePolicy? framePolicy,
}) {
  _CustomGherkinIntegrationTestRunner(
    configuration: configuration,
    appMainFunction: appMainFunction,
    appLifecyclePumpHandler: appLifecyclePumpHandler,
    scenarioExecutionTimeout: scenarioExecutionTimeout,
    framePolicy: framePolicy,
  ).run();
}
