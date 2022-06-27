library flutter_gherkin;

/// ***************************************
/// Library export for use with integration_test with include reference to flutter_test which reference dart:ui
/// which are not allowed when running tests with flutter_driver hence this separate library declaration file
/// ***************************************

// Flutter specific implementations
export 'src/flutter/configuration/build_mode.dart';
export 'src/flutter/world/flutter_world.dart';
export 'src/flutter/configuration/flutter_test_configuration.dart';
export 'src/flutter/adapters/app_driver_adapter.dart';

// Well known steps
export 'src/flutter/steps/given_i_open_the_drawer_step.dart';
export 'src/flutter/steps/then_expect_element_to_have_value_step.dart';
export 'src/flutter/steps/when_fill_field_step.dart';
export 'src/flutter/steps/when_pause_step.dart';
export 'src/flutter/steps/when_tap_widget_step.dart';
export 'src/flutter/steps/restart_app_step.dart';
export 'src/flutter/steps/sibling_contains_text_step.dart';
export 'src/flutter/steps/swipe_step.dart';
export 'src/flutter/steps/tap_text_within_widget_step.dart';
export 'src/flutter/steps/tap_widget_of_type_step.dart';
export 'src/flutter/steps/tap_widget_of_type_within_step.dart';
export 'src/flutter/steps/tap_widget_with_text_step.dart';
export 'src/flutter/steps/text_exists_step.dart';
export 'src/flutter/steps/text_exists_within_step.dart';
export 'src/flutter/steps/wait_until_key_exists_step.dart';
export 'src/flutter/steps/when_tap_the_back_button_step.dart';
export 'src/flutter/steps/wait_until_type_exists_step.dart';
export 'src/flutter/steps/wait_until_key_exists_step.dart';
export 'src/flutter/steps/take_a_screenshot_step.dart';

// Hooks
export 'src/flutter/hooks/attach_screenshot_on_failed_step_hook.dart';

// integration_test specific exports
export 'src/flutter/adapters/widget_tester_app_driver_adapter.dart';
export 'src/flutter/code_generation/annotations/gherkin_full_test_suite_annotation.dart';
export 'src/flutter/runners/gherkin_integration_test_runner.dart';
export 'src/flutter/world/flutter_widget_tester_world.dart';
