// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gherkin_suite_test.dart';

// **************************************************************************
// GherkinSuiteTestGenerator
// **************************************************************************

class _CustomGherkinIntegrationTestRunner extends GherkinIntegrationTestRunner {
  _CustomGherkinIntegrationTestRunner(
    FlutterTestConfiguration configuration,
    void Function() appMainFunction,
  ) : super(configuration, appMainFunction);

  @override
  void onRun() {
    testFeature0();
  }

  void testFeature0() {
    group(
      'Counter:',
      () {
        testWidgets(
          'User can increment the counter',
          (WidgetTester tester) async {
            final dependencies = await createTestDependencies(
              configuration,
              tester,
            );

            await startApp(tester);

            await runStep(
              'Given I expect the "counter" to be "0"',
              [],
              null,
              dependencies.world,
            );

            await runStep(
              'When I tap the "increment" button',
              [],
              null,
              dependencies.world,
            );

            await runStep(
              'Then I expect the "counter" to be "1"',
              [],
              null,
              dependencies.world,
            );
          },
          timeout: scenarioExecutionTimeout,
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
