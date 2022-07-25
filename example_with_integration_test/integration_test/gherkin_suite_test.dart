import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import 'gherkin/configuration.dart';

part 'gherkin_suite_test.g.dart';

@GherkinTestSuite(
  useAbsolutePaths: false,
)
void main() {
  executeTestSuite(
    appMainFunction: appInitializationFn,
    configuration: gherkinTestConfiguration,
    // if you have lots of test you might need to increase the default timeout
    // scenarioExecutionTimeout: Timeout(const Duration(minutes: 30)),
    // if your app has lots of endless animations you might need to
    // provide your own app lifecycle pump handler that doesn't pump
    // at certain lifecycle stages
    // appLifecyclePumpHandler: (appPhase, widgetTester) async => {},
    // you can increase the performance of your tests at the cost of
    // not drawing some frames but it might lead to unexpected consequences
    // framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive,
  );
}
