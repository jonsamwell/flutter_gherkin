import 'package:integration_test/integration_test_driver.dart'
    as integration_test_driver;

Future<void> main() {
  const maximumTestRunDuration = Duration(minutes: 90);
  // Tests will write any output files to this directory
  integration_test_driver.testOutputsDirectory = './';

  return integration_test_driver.integrationDriver(
      timeout: maximumTestRunDuration);
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
