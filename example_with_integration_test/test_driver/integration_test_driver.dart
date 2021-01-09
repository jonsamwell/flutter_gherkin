import 'package:integration_test/integration_test_driver.dart'
    as integration_test_driver;

Future<void> main() {
  // The Gherkin report data send back to this runner by the app after
  // the tests have run will be saved to this directory
  integration_test_driver.testOutputsDirectory =
      'integration_test/gherkin_reports';

  return integration_test_driver.integrationDriver(
    timeout: Duration(minutes: 90),
  );
}

// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:integration_test/integration_test_driver_extended.dart';

// Future<void> main() async {
//   final driver = await FlutterDriver.connect();

//   await integrationDriver(
//     driver: driver,
//     onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
//       return true;
//     },
//   );
// }
