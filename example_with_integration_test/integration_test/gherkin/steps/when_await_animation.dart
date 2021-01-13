import 'package:flutter/widgets.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_gherkin/flutter_gherkin_integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

final whenAnAnimationIsAwaited = when1<int, FlutterWidgetTesterWorld>(
  'I wait {int} seconds for the animation to complete',
  (duration, context) async {
    final tester = context.world.appDriver.rawDriver;

    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        Duration(seconds: duration),
      );
      // ignore: avoid_catching_errors
    } on FlutterError {
      // pump for 2 seconds and stop
    }
  },
  configuration: StepDefinitionConfiguration()
    ..timeout = const Duration(minutes: 5),
);
