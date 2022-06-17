// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gherkin_suite_test.dart';

// **************************************************************************
// GherkinSuiteTestGenerator
// **************************************************************************

class _CustomGherkinIntegrationTestRunner extends GherkinIntegrationTestRunner {
  _CustomGherkinIntegrationTestRunner(
    TestConfiguration configuration,
    Future<void> Function(World) appMainFunction,
  ) : super(configuration, appMainFunction);

  @override
  void onRun() {
    testFeature0();
    testFeature1();
    testFeature2();
  }

  void testFeature0() {
    runFeature(
      'Swiping:',
      <String>['@tag'],
      () {
        runScenario(
          name: 'User can swipe cards left and right',
          path:
              'C:\Development\github\flutter_gherkin\example_with_integration_test\.\integration_test\features\swiping.feature',
          tags: <String>['@tag'],
          steps: [
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Given I swipe right by 250 pixels on the "scrollable cards"`',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Then Then I expect the text "Page 2" to be present',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Given I swipe left by 250 pixels on the "scrollable cards"`',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Then Then I expect the text "Page 1" to be present',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            }
          ],
          onBefore: () async => onBeforeRunFeature(
            'Swiping',
            <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature('Swiping',
              'C:\Development\github\flutter_gherkin\example_with_integration_test\.\integration_test\features\swiping.feature'),
        );
      },
    );
  }

  void testFeature1() {
    runFeature(
      'Creating todos:',
      <String>['@tag'],
      () {
        runScenario(
          name: 'User can create multiple new todo items',
          path:
              'C:\Development\github\flutter_gherkin\example_with_integration_test\.\integration_test\features\create.feature',
          tags: <String>['@tag', '@debug'],
          steps: [
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Given I fill the "todo" field with "Buy carrots"',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'When I tap the "add" button',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'And I fill the "todo" field with "Buy apples"',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'When I tap the "add" button',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'And I fill the "todo" field with "Buy blueberries"',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'When I tap the "add" button',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Then I expect the todo list',
                <String>[],
                GherkinTable.fromJson(
                    '[{"Todo":"Buy blueberries"},{"Todo":"Buy apples"},{"Todo":"Buy carrots"}]'),
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Given I wait 5 seconds for the animation to complete',
                <String>[],
                null,
                dependencies,
                hasToSkip,
              );
            },
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Given I have item with data',
                <String>[
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
                null,
                dependencies,
                hasToSkip,
              );
            }
          ],
          onBefore: () async => onBeforeRunFeature(
            'Creating todos',
            <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature('Creating todos',
              'C:\Development\github\flutter_gherkin\example_with_integration_test\.\integration_test\features\create.feature'),
        );
      },
    );
  }

  void testFeature2() {
    runFeature(
      'Checking data:',
      <String>['@tag'],
      () {
        runScenario(
          name: 'User can have data',
          path:
              'C:\Development\github\flutter_gherkin\example_with_integration_test\.\integration_test\features\check.feature',
          tags: <String>['@tag', '@tag1'],
          steps: [
            (TestDependencies dependencies, bool hasToSkip) async {
              return await runStep(
                'Given I have item with data',
                <String>[
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
                null,
                dependencies,
                hasToSkip,
              );
            }
          ],
          onBefore: () async => onBeforeRunFeature(
            'Checking data',
            <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature('Checking data',
              'C:\Development\github\flutter_gherkin\example_with_integration_test\.\integration_test\features\check.feature'),
        );
      },
    );
  }
}

void executeTestSuite(
  TestConfiguration configuration,
  Future<void> Function(World) appMainFunction,
) {
  _CustomGherkinIntegrationTestRunner(configuration, appMainFunction).run();
}
