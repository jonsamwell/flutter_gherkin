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
      'Checking data:',
      <String>['@tag'],
      () {
        runScenario(
          'User can have data',
          <String>['@tag', '@tag1'],
          (TestDependencies dependencies) async {
            await runStep(
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
            );
          },
          onBefore: () async => onBeforeRunFeature(
            'Checking data',
            <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature(
            'Checking data',
          ),
        );
      },
    );
  }

  void testFeature1() {
    runFeature(
      'Swiping:',
      <String>['@tag'],
      () {
        runScenario(
          'User can swipe cards left and right',
          <String>['@tag', '@debug'],
          (TestDependencies dependencies) async {
            await runStep(
              'Given I swipe right by 250 pixels on the "scrollable cards"`',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'Then Then I expect the text "Page 2" to be present',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'Given I swipe left by 250 pixels on the "scrollable cards"`',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'Then Then I expect the text "Page 1" to be present',
              <String>[],
              null,
              dependencies,
            );
          },
          onBefore: () async => onBeforeRunFeature(
            'Swiping',
            <String>['@tag'],
          ),
          onAfter: () async => onAfterRunFeature(
            'Swiping',
          ),
        );
      },
    );
  }

  void testFeature2() {
    runFeature(
      'Creating todos:',
      <String>['@tag'],
      () {
        runScenario(
          'User can create a new todo item',
          <String>['@tag', '@tag1', '@tag_two'],
          (TestDependencies dependencies) async {
            await runStep(
              'Given I fill the "todo" field with "Buy carrots"',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'When I tap the \'add\' button',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'Then I expect the todo list',
              <String>[],
              GherkinTable.fromJson('[{"Todo":"Buy carrots"}]'),
              dependencies,
            );
          },
          onBefore: () async => onBeforeRunFeature(
            'Creating todos',
            <String>['@tag'],
          ),
          onAfter: null,
        );

        runScenario(
          'User can create multiple new todo items',
          <String>['@tag', '@debug'],
          (TestDependencies dependencies) async {
            await runStep(
              'Given I fill the "todo" field with "Buy carrots"',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'When I tap the "add" button',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'And I fill the "todo" field with "Buy apples"',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'When I tap the "add" button',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'And I fill the "todo" field with "Buy blueberries"',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'When I tap the "add" button',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'Then I expect the todo list',
              <String>[],
              GherkinTable.fromJson(
                  '[{"Todo":"Buy blueberries"},{"Todo":"Buy apples"},{"Todo":"Buy carrots"}]'),
              dependencies,
            );

            await runStep(
              'Given I wait 5 seconds for the animation to complete',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
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
            );
          },
          onBefore: null,
          onAfter: () async => onAfterRunFeature(
            'Creating todos',
          ),
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
