import 'package:flutter_gherkin/flutter_gherkin_integration_test.dart';
import 'package:gherkin/gherkin.dart';

import 'gherkin/configuration.dart';

part 'gherkin_suite_test.g.dart';

@GherkinTestSuite()
void main() {
  executeTestSuite(
    gherkinTestConfiguration,
    appInitializationFn,
  );
}
