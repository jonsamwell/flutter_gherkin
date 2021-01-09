// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gherkin_suite_test.dart';

// **************************************************************************
// GherkinSuiteTestGenerator
// **************************************************************************

class _CustomGherkinIntegrationTestRunner extends GherkinIntegrationTestRunner {
  _CustomGherkinIntegrationTestRunner(
    TestConfiguration configuration,
    void Function() appMainFunction,
  ) : super(configuration, appMainFunction);

  @override
  void onRun() {
    testFeature0();
  }

  void testFeature0() {
    runFeature(
      'Counter:',
      ['@tag'],
      () async {
        runScenario(
          'User can increment the counter',
          ['@tag', '@tag1', '@tag_two'],
          (TestDependencies dependencies) async {
            await runStep(
              'Given I expect the "counter" to be "0"',
              [],
              null,
              dependencies,
            );

            await runStep(
              'When I tap the "increment" button',
              [],
              null,
              dependencies,
            );

            await runStep(
              'Then I expect the "counter" to be "1"',
              [],
              null,
              dependencies,
            );

            await runStep(
              'Given the table',
              [],
              Table.fromJson(
                  '[{"Header One":"1","Header Two":"2","Header Three":"3"},{"Header One":"4","Header Two":"5","Header Three":"6"}]'),
              dependencies,
            );
          },
        );
      },
    );
  }
}

void executeTestSuite(
  TestConfiguration configuration,
  void Function() appMainFunction,
) {
  _CustomGherkinIntegrationTestRunner(configuration, appMainFunction).run();
}
