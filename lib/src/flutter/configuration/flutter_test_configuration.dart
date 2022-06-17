import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:flutter_gherkin/src/flutter/parameters/existence_parameter.dart';
import 'package:flutter_gherkin/src/flutter/parameters/swipe_direction_parameter.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_widget_to_be_present_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_long_press_widget_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

class FlutterTestConfiguration extends TestConfiguration {
  static final Iterable<CustomParameter<dynamic>> _wellKnownParameters = [
    ExistenceParameter(),
    SwipeDirectionParameter(),
  ];
  static final _wellKnownStepDefinitions = [
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
  ];

  /// Enable semantics in a test by creating a [SemanticsHandle].
  /// See:  [testWidgets] and [WidgetController.ensureSemantics].
  final bool semanticsEnabled;

  /// Set to `True` to wait implicit for pumpAndSettle() / waitForAppToSettle() functions after performing actions
  /// Defaults to false
  final bool waitImplicitlyAfterAction;

  /// Provide a configuration object with default settings such as the reports and feature file location
  /// Additional setting on the configuration object can be set on the returned instance.
  static FlutterTestConfiguration DEFAULT(
    Iterable<StepDefinitionGeneric<World>> steps, {
    String featurePath = 'integration_test/features/*.*.feature',
    String targetAppPath = 'test_driver/integration_test_driver.dart',
  }) {
    return FlutterTestConfiguration(
      reporters: [
        StdoutReporter(MessageLevel.error),
        ProgressReporter(),
        TestRunSummaryReporter(),
        // JsonReporter(path: './report.json'),
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
          customStepParameterDefinitions:
              List.from(customStepParameterDefinitions ?? Iterable.empty())
                ..addAll(_wellKnownParameters),
          stepDefinitions: List.from(stepDefinitions ?? Iterable.empty())
            ..addAll(_wellKnownStepDefinitions),
        );
}
