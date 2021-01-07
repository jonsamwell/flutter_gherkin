import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

// The application under test.
import 'package:example_with_integration_test/main.dart' as app;

part 'gherkin_suite_test.g.dart';

@GherkinTestSuite()
void main() {
  executeTestSuite(
    FlutterTestConfiguration.DEFAULT([]),
    app.main,
  );
}
