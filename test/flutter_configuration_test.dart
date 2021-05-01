import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart' as test;

import 'mocks/parameter_mock.dart';
import 'mocks/step_definition_mock.dart';

void main() {
  group('config', () {
    group('prepare', () {
      test.test('flutter app runner hook added', () {
        final config = FlutterDriverTestConfiguration();
        expect(config.hooks, isNull);
        config.prepare();
        expect(config.hooks, isNotNull);
        expect(config.hooks!.length, 1);
        expect(config.hooks!.elementAt(0), (x) => x is FlutterAppRunnerHook);
      });

      test.test('common steps definition added', () {
        final config = FlutterDriverTestConfiguration();
        expect(config.stepDefinitions, isNull);

        config.prepare();
        expect(config.stepDefinitions, isNotNull);
        expect(config.stepDefinitions!.length, 23);
        expect(config.customStepParameterDefinitions, isNotNull);
        expect(config.customStepParameterDefinitions!.length, 2);
      });

      test.test('common step definition added to existing steps', () {
        final config = FlutterTestConfiguration()
          ..stepDefinitions = [MockStepDefinition()]
          ..customStepParameterDefinitions = [MockParameter()];
        expect(config.stepDefinitions!.length, 1);

        config.prepare();
        expect(config.stepDefinitions, isNotNull);
        expect(config.stepDefinitions!.length, 24);
        expect(config.stepDefinitions!.elementAt(0),
            (x) => x is MockStepDefinition);
        expect(config.customStepParameterDefinitions, isNotNull);
        expect(config.customStepParameterDefinitions!.length, 3);
        expect(config.customStepParameterDefinitions!.elementAt(0),
            (x) => x is MockParameter);
      });
    });
  });
}
