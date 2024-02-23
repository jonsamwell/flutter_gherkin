import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric restartAppStep() {
  return given<FlutterWorld>(
    'I restart the app',
    (context) async {
      await context.world.restartApp(
        timeout: context.configuration.timeout,
      );
    },
  );
}
