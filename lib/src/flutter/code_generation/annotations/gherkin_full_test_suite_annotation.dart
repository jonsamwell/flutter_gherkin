import 'package:gherkin/gherkin.dart';

/// An annotation used to specify a class to generate Gherkin tests that adhere
/// to the style required by the integration_test package
class GherkinTestSuite {
  /// Path to the feature files to generate tests for
  final Iterable<Pattern> featurePaths;

  /// The execution order of features - this default to random to avoid any inter-test dependencies
  final ExecutionOrder executionOrder;

  /// The default feature language
  final String featureDefaultLanguage;

  /// True (the default) to use absolute file paths for reporters
  final bool useAbsolutePaths;

  const GherkinTestSuite({
    this.executionOrder = ExecutionOrder.random,
    this.featureDefaultLanguage = 'en',
    this.featurePaths = const <String>['integration_test/features/**.feature'],
    this.useAbsolutePaths = true,
  });
}
