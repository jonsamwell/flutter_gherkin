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
  );
}
