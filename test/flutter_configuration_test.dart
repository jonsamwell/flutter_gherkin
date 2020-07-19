import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:test/test.dart';

import 'mocks/step_definition_mock.dart';

void main() {
  group('config', () {
    group('prepare', () {
      test('flutter app runner hook added', () {
        final config = FlutterTestConfiguration();
        expect(config.hooks, isNull);
        config.prepare();
        expect(config.hooks, isNotNull);
        expect(config.hooks.length, 1);
        expect(config.hooks.elementAt(0), (x) => x is FlutterAppRunnerHook);
      });

      test('common steps definition added', () {
        final config = FlutterTestConfiguration();
        expect(config.stepDefinitions, isNull);

        config.prepare();
        expect(config.stepDefinitions, isNotNull);
        expect(config.stepDefinitions.length, 9);
      });

      test('common step definition added to existing steps', () {
        final config = FlutterTestConfiguration()
          ..stepDefinitions = [MockStepDefinition()];
        expect(config.stepDefinitions.length, 1);

        config.prepare();
        expect(config.stepDefinitions, isNotNull);
        expect(config.stepDefinitions.length, 10);
        expect(config.stepDefinitions.elementAt(0),
            (x) => x is MockStepDefinition);
      });
    });
  });
}
