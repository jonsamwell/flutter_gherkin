import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/common.dart';
import 'package:integration_test/integration_test_driver.dart'
    as integration_test_driver;

DriverLogCallback logDriverMessages = (String source, String message) {
  final msg = '$source: $message';
  if (message.toLowerCase().contains('error')) {
    stderr.writeln(msg);
  } else {
    stdout.writeln(msg);
  }
};

Future<void> main() {
  // Flutter Driver logs all messages to stderr by default so if this is run on a build server
  // the process will fail due to writing errors. So handle this yourself for now
  driverLog = logDriverMessages;
  // The Gherkin report data send back to this runner by the app after
  // the tests have run will be saved to this directory
  integration_test_driver.testOutputsDirectory =
      'integration_test/gherkin/reports';

  return integrationDriver();
}

// Rre-implement this rather than using `integration_test_driver.integrationDriver()`
// so that failed test runs will have reports saved to disk rather than just exiting
Future<void> integrationDriver({
  Duration timeout = const Duration(minutes: 60),
}) async {
  final FlutterDriver driver = await FlutterDriver.connect();
  final String jsonResult = await driver.requestData(null, timeout: timeout);
  final Response response = Response.fromJson(jsonResult);

  await driver.close();

  final reports = json.decode(response.data!['gherkin_reports'].toString())
      as List<dynamic>;

  await writeGherkinReports(reports);

  if (response.allTestsPassed) {
    exit(0);
  } else {
    print('Failure Details:\n${response.formattedFailureDetails}');
    exit(1);
  }
}

Future<void> writeGherkinReports(List<dynamic> reports) async {
  final filenamePrefix =
      DateTime.now().toIso8601String().split('.').first.replaceAll(':', '-');

  for (var i = 0; i < reports.length; i += 1) {
    final reportData = reports.elementAt(i) as List<dynamic>;

    await fs
        .directory(integration_test_driver.testOutputsDirectory)
        .create(recursive: true);
    File file = File(
      '${integration_test_driver.testOutputsDirectory}/'
      '$filenamePrefix'
      '-v${i + 1}.json',
    );

    await file.writeAsString(json.encode(reportData));
  }
}
