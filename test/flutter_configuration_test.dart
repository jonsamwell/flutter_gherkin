import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_gherkin/src/flutter/steps/given_i_open_the_drawer_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/restart_app_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_element_to_have_value_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_fill_field_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_pause_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_widget_step.dart';
import 'package:test/test.dart';

import 'mocks/step_definition_mock.dart';

void main() {
  group("config", () {
    group("prepare", () {
      test("flutter app runner hook added", () {
        final config = FlutterTestConfiguration();
        expect(config.hooks, isNull);
        config.prepare();
        expect(config.hooks, isNotNull);
        expect(config.hooks.length, 1);
        expect(config.hooks.elementAt(0), (x) => x is FlutterAppRunnerHook);
      });

      test("common step definition added", () {
        final config = FlutterTestConfiguration();
        expect(config.stepDefinitions, isNull);

        config.prepare();
        expect(config.stepDefinitions, isNotNull);
        expect(config.stepDefinitions.length, 6);
        expect(config.stepDefinitions.elementAt(0),
            (x) => x is ThenExpectElementToHaveValue);
        expect(config.stepDefinitions.elementAt(1), (x) => x is WhenTapWidget);
        expect(
            config.stepDefinitions.elementAt(2), (x) => x is GivenOpenDrawer);
        expect(config.stepDefinitions.elementAt(3), (x) => x is WhenPauseStep);
        expect(
            config.stepDefinitions.elementAt(4), (x) => x is WhenFillFieldStep);
        expect(config.stepDefinitions.elementAt(5), (x) => x is RestartAppStep);
      });

      test("common step definition added to existing steps", () {
        final config = FlutterTestConfiguration()
          ..stepDefinitions = [MockStepDefinition()];
        expect(config.stepDefinitions.length, 1);

        config.prepare();
        expect(config.stepDefinitions, isNotNull);
        expect(config.stepDefinitions.length, 7);
        expect(config.stepDefinitions.elementAt(0),
            (x) => x is MockStepDefinition);
        expect(config.stepDefinitions.elementAt(1),
            (x) => x is ThenExpectElementToHaveValue);
      });
    });
  });
}
