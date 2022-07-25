// ignore_for_file: avoid_print

import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:flutter_gherkin/src/flutter/parameters/existence_parameter.dart';
import 'package:flutter_gherkin/src/flutter/parameters/swipe_direction_parameter.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_widget_to_be_present_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_long_press_widget_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../steps/take_a_screenshot_step.dart';

class FlutterTestConfiguration extends TestConfiguration {
  static final Iterable<CustomParameter<dynamic>> _wellKnownParameters = [
    ExistenceParameter(),
    SwipeDirectionParameter(),
  ];
  static final _wellKnownStepDefinitions = [
    SwipeOnKeyStep(),
    SwipeOnTextStep(),
    thenExpectElementToHaveValue(),
    whenTapBackButtonWidget(),
    whenTapWidget(),
    whenTapWidgetWithoutScroll(),
    whenLongPressWidget(),
    whenLongPressWidgetWithoutScroll(),
    whenLongPressWidgetForDuration(),
    givenOpenDrawer(),
    whenPauseStep(),
    whenFillFieldStep(),
    thenExpectWidgetToBePresent(),
    restartAppStep(),
    siblingContainsTextStep(),
    tapTextWithinWidgetStep(),
    tapWidgetOfTypeStep(),
    tapWidgetOfTypeWithinStep(),
    tapWidgetWithTextStep(),
    textExistsStep(),
    textExistsWithinStep(),
    waitUntilKeyExistsStep(),
    waitUntilTypeExistsStep(),
    takeScreenshot(),
  ];

  /// Enable semantics in a test by creating a [SemanticsHandle].
  /// See:  [testWidgets] and [WidgetController.ensureSemantics].
  final bool semanticsEnabled;

  /// Set to `True` to wait implicit for pumpAndSettle() / waitForAppToSettle() functions after performing actions
  /// Defaults to false
  final bool waitImplicitlyAfterAction;

  /// Provide a configuration object with default settings
  static FlutterTestConfiguration standard(
    Iterable<StepDefinitionGeneric<World>> steps,
  ) {
    return FlutterTestConfiguration(
      reporters: [
        StdoutReporter(MessageLevel.error),
        ProgressReporter(),
        TestRunSummaryReporter(),
      ],
      stepDefinitions: steps,
    );
  }

  /// Provide a configuration object with default settings for web
  static FlutterTestConfiguration standardWeb(
    Iterable<StepDefinitionGeneric<World>> steps,
  ) {
    return FlutterTestConfiguration(
      reporters: [
        StdoutReporter(MessageLevel.error)
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        ProgressReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        TestRunSummaryReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
      ],
      stepDefinitions: steps,
    );
  }

  FlutterTestConfiguration({
    super.features = const <Pattern>[],
    super.featureDefaultLanguage = 'en',
    super.order = ExecutionOrder.random,
    super.defaultTimeout = const Duration(seconds: 10),
    super.featureFileMatcher = const IoFeatureFileAccessor(),
    super.featureFileReader = const IoFeatureFileAccessor(),
    super.stopAfterTestFailed = false,
    super.tagExpression,
    super.hooks,
    super.reporters = const [],
    super.createWorld,
    this.semanticsEnabled = true,
    this.waitImplicitlyAfterAction = false,
    Iterable<CustomParameter<dynamic>>? customStepParameterDefinitions,
    Iterable<StepDefinitionGeneric<World>>? stepDefinitions,
  }) : super(
          customStepParameterDefinitions: List.from(
            customStepParameterDefinitions ?? const Iterable.empty(),
          )..addAll(_wellKnownParameters),
          stepDefinitions: List.from(
            stepDefinitions ?? const Iterable.empty(),
          )..addAll(_wellKnownStepDefinitions),
        );
}
