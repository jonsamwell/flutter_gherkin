import 'package:flutter_gherkin/flutter_gherkin.dart';
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
