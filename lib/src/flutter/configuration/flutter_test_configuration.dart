import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:flutter_gherkin/src/flutter/parameters/existence_parameter.dart';
import 'package:flutter_gherkin/src/flutter/parameters/swipe_direction_parameter.dart';
import 'package:flutter_gherkin/src/flutter/steps/given_i_open_the_drawer_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/restart_app_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/sibling_contains_text_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/swipe_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_text_within_widget_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_widget_of_type_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_widget_of_type_within_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_widget_with_text_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/text_exists_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/text_exists_within_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_element_to_have_value_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_widget_to_be_present_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/wait_until_key_exists_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/wait_until_type_exists_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_fill_field_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_long_press_widget_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_pause_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_widget_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_the_back_button_step.dart';
import 'package:gherkin/gherkin.dart';

class FlutterTestConfiguration extends TestConfiguration {
  @deprecated

  /// ~~The path(s) to all the features.~~
  /// ~~All three [Pattern]s are supported: [RegExp], [String], [Glob].~~
  ///
  /// Instead of using this variable, give the features in the `@GherkinTestSuite(features: <String>[])` option.
  Iterable<Pattern> features = const <Pattern>[];

  /// ~~The execution order of features - this default to random to avoid any inter-test dependencies~~
  ///
  /// Instead of using this variable, give the executionOrder in the `@GherkinTestSuite(executionOrder: ExecutionOrder.random)` option.
  @deprecated
  ExecutionOrder order = ExecutionOrder.random;

  /// ~~Lists feature files paths, which match [features] patterns.~~
  ///
  /// Instead of using this variable, give the features in the `@GherkinTestSuite(features: <String>[])` option.
  @deprecated
  FeatureFileMatcher featureFileMatcher = const IoFeatureFileAccessor();

  /// ~~The feature file reader.~~
  /// ~~Takes files/resources paths from [featureFileIndexer] and returns their content as String.~~
  ///
  /// Instead of using this variable, give the features in the `@GherkinTestSuite(features: <String>[])` option.
  @deprecated
  FeatureFileReader featureFileReader = const IoFeatureFileAccessor();

  /// Provide a configuration object with default settings such as the reports and feature file location
  /// Additional setting on the configuration object can be set on the returned instance.
  static FlutterTestConfiguration DEFAULT(
    Iterable<StepDefinitionGeneric<World>> steps, {
    String featurePath = 'integration_test/features/*.*.feature',
    String targetAppPath = 'test_driver/integration_test_driver.dart',
  }) {
    return FlutterTestConfiguration()
      ..features = [RegExp(featurePath)]
      ..reporters = [
        StdoutReporter(MessageLevel.error),
        ProgressReporter(),
        TestRunSummaryReporter(),
        // JsonReporter(path: './report.json'),
      ]
      ..stepDefinitions = steps;
  }

  @override
  void prepare() {
    customStepParameterDefinitions =
        List.from(customStepParameterDefinitions ?? Iterable.empty())
          ..addAll([
            ExistenceParameter(),
            SwipeDirectionParameter(),
          ]);
    stepDefinitions = List.from(stepDefinitions ?? Iterable.empty())
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
      ]);
  }
}
