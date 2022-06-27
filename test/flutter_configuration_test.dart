import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mocks/parameter_mock.dart';
import 'mocks/step_definition_mock.dart';

void main() {
  group('config', () {
    test('flutter app runner hook added', () {
      final config = FlutterDriverTestConfiguration();
      final newConfig = config.prepare();

      expect(newConfig.hooks, isNotNull);
      expect(newConfig.hooks!.length, 1);
      expect(newConfig.hooks!.elementAt(0), (x) => x is FlutterAppRunnerHook);
    });

    test('common steps definition added', () {
      final config = FlutterDriverTestConfiguration();
      expect(config.stepDefinitions, isNotNull);
      expect(config.stepDefinitions!.length, 24);
      expect(config.customStepParameterDefinitions, isNotNull);
      expect(config.customStepParameterDefinitions!.length, 2);
    });

    test('common step definition added to existing steps', () {
      final config = FlutterTestConfiguration(
        stepDefinitions: [MockStepDefinition()],
        customStepParameterDefinitions: [MockParameter()],
      );

      expect(config.stepDefinitions, isNotNull);
      expect(config.stepDefinitions!.length, 25);
      expect(
          config.stepDefinitions!.elementAt(0), (x) => x is MockStepDefinition);
      expect(config.customStepParameterDefinitions, isNotNull);
      expect(config.customStepParameterDefinitions!.length, 3);
      expect(config.customStepParameterDefinitions!.elementAt(0),
          (x) => x is MockParameter);
    });
  });
}
