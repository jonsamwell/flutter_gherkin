import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:flutter_gherkin/src/flutter/parameters/existence_parameter.dart';
import 'package:flutter_gherkin/src/flutter/parameters/swipe_direction_parameter.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_widget_to_be_present_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_long_press_widget_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

class FlutterTestConfiguration extends TestConfiguration {
  FlutterTestConfiguration({
    Iterable<Pattern> features = const <Pattern>[],
    String featureDefaultLanguage = 'en',
    ExecutionOrder order = ExecutionOrder.random,
    Duration defaultTimeout = const Duration(seconds: 10),
    FeatureFileMatcher featureFileMatcher = const IoFeatureFileAccessor(),
    FeatureFileReader featureFileReader = const IoFeatureFileAccessor(),
    bool stopAfterTestFailed = false,
    String? tagExpression,
    Iterable<StepDefinitionGeneric>? stepDefinitions,
    Iterable<CustomParameter<dynamic>>? customStepParameterDefinitions,
    Iterable<Hook>? hooks,
    Iterable<Reporter> reporters = const [],
    CreateWorld? createWorld,
    this.semanticsEnabled,
  }) : super(
          features: features,
          featureDefaultLanguage: featureDefaultLanguage,
          order: order,
          defaultTimeout: defaultTimeout,
          featureFileMatcher: featureFileMatcher,
          featureFileReader: featureFileReader,
          stopAfterTestFailed: stopAfterTestFailed,
          tagExpression: tagExpression,
          stepDefinitions: List.from(stepDefinitions ?? Iterable.empty())
            ..addAll([
              ThenExpectElementToHaveValue(),
              WhenTapBackButtonWidget(),
              WhenTapWidget(),
              WhenTapWidgetWithoutScroll(),
              WhenLongPressWidget(),
              WhenLongPressWidgetWithoutScroll(),
              WhenLongPressWidgetForDuration(),
              GivenOpenDrawer(),
              WhenPauseStep(),
              WhenFillFieldStep(),
              ThenExpectWidgetToBePresent(),
              RestartAppStep(),
              SiblingContainsTextStep(),
              SwipeOnKeyStep(),
              SwipeOnTextStep(),
              TapTextWithinWidgetStep(),
              TapWidgetOfTypeStep(),
              TapWidgetOfTypeWithinStep(),
              TapWidgetWithTextStep(),
              TextExistsStep(),
              TextExistsWithinStep(),
              WaitUntilKeyExistsStep(),
              WaitUntilTypeExistsStep(),
            ]),
          customStepParameterDefinitions:
              List.from(customStepParameterDefinitions ?? Iterable.empty())
                ..addAll([
                  ExistenceParameter(),
                  SwipeDirectionParameter(),
                ]),
          hooks: hooks,
          reporters: reporters,
          createWorld: createWorld,
        );

  /// Provide a configuration object with default settings such as the reports and feature file location
  /// Additional setting on the configuration object can be set on the returned instance.
  static FlutterTestConfiguration DEFAULT(
    Iterable<StepDefinitionGeneric<World>> steps, {
    String featurePath = 'integration_test/features/*.*.feature',
    String targetAppPath = 'test_driver/integration_test_driver.dart',
    String featureDefaultLanguage = 'en',
    ExecutionOrder order = ExecutionOrder.random,
    Duration defaultTimeout = const Duration(seconds: 10),
    FeatureFileMatcher featureFileMatcher = const IoFeatureFileAccessor(),
    FeatureFileReader featureFileReader = const IoFeatureFileAccessor(),
    bool stopAfterTestFailed = false,
    String? tagExpression,
    Iterable<CustomParameter<dynamic>>? customStepParameterDefinitions,
    Iterable<Hook>? hooks,
    Iterable<Reporter>? reporters,
    CreateWorld? createWorld,
    bool semanticsEnabled = true,
  }) {
    return FlutterTestConfiguration(
      stepDefinitions: steps,
      features: [RegExp(featurePath)],
      reporters: reporters ??
          [
            StdoutReporter(MessageLevel.error),
            ProgressReporter(),
            TestRunSummaryReporter(),
            // JsonReporter(path: './report.json'),
          ],
      featureDefaultLanguage: featureDefaultLanguage,
      order: order,
      defaultTimeout: defaultTimeout,
      featureFileMatcher: featureFileMatcher,
      featureFileReader: featureFileReader,
      stopAfterTestFailed: stopAfterTestFailed,
      tagExpression: tagExpression,
      customStepParameterDefinitions: customStepParameterDefinitions,
      hooks: hooks,
      createWorld: createWorld,
      semanticsEnabled: semanticsEnabled,
    );
  }

  /// Enable semantics in a test by creating a [SemanticsHandle].
  /// See:  [testWidgets] and [WidgetController.ensureSemantics].
  final semanticsEnabled;
}
