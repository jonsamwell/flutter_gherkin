import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric TapButtonNTimesStep() {
  return given2<String, int, FlutterWorld>(
    'I tap the {string} button {int} times',
    (key, count, context) async {
      final locator = context.world.appDriver.findBy(key, FindType.key);
      for (var i = 0; i < count; i += 1) {
        await context.world.appDriver.tap(locator);
      }
    },
  );
}
