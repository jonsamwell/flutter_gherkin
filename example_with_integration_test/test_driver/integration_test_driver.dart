import 'package:integration_test/integration_test_driver.dart'
    as integration_test_driver;

Future<void> main() {
  // The Gherkin report data send back to this runner by the app after
  // the tests have run will be saved to this directory
  integration_test_driver.testOutputsDirectory =
      'integration_test/gherkin/reports';

  return integration_test_driver.integrationDriver(
    timeout: Duration(minutes: 90),
  );
}
