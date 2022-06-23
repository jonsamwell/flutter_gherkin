import 'package:flutter_gherkin/src/flutter/adapters/app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Expects a widget with the given key to be present within n seconds
///
/// Parameters:
///   1 - {string} the control key
///
/// Examples:
///
///   `Then I expect the widget 'notification' to be present within 10 seconds`
///   `Then I expect the button 'save' to be present within 1 second`
StepDefinitionGeneric thenExpectWidgetToBePresent() {
  return given2<String, int, FlutterWorld>(
    RegExp(
        r'I expect the (?:button|element|label|icon|field|text|widget|dialog|popup) {string} to be present within {int} second(s)$'),
    (key, seconds, context) async {
      await context.world.appDriver.waitUntil(
        () async {
          await context.world.appDriver.waitForAppToSettle();

          return context.world.appDriver.isPresent(
            context.world.appDriver.findBy(key, FindType.key),
          );
        },
        timeout: Duration(seconds: seconds),
      );
    },
    configuration: StepDefinitionConfiguration()
      ..timeout = const Duration(days: 1),
  );
}
