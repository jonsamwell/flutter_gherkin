import 'package:flutter_gherkin/src/flutter/adapters/app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Long presses the widget found with the given control key.
///
/// Parameters:
///   1 - {string} the control key
///
/// Examples:
///
///   `When I long press "controlKey" button`
///   `When I long press "controlKey" element`
///   `When I long press "controlKey" label`
///   `When I long press "controlKey" icon`
///   `When I long press "controlKey" field`
///   `When I long press "controlKey" text`
///   `When I long press "controlKey" widget`
StepDefinitionGeneric whenLongPressWidget() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I long press the {string} (?:button|element|label|icon|field|text|widget)$'),
    (key, context) async {
      final finder = context.world.appDriver.findBy(key, FindType.key);

      await context.world.appDriver.scrollIntoView(finder);
      await context.world.appDriver.longPress(finder);
      await context.world.appDriver.waitForAppToSettle();
    },
  );
}

/// Long presses the widget found with the given control key, without scrolling into view
StepDefinitionGeneric whenLongPressWidgetWithoutScroll() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I long press the {string} (?:button|element|label|icon|field|text|widget) without scrolling it into view$'),
    (key, context) async {
      final finder = context.world.appDriver.findBy(key, FindType.key);

      await context.world.appDriver.longPress(
        finder,
      );
    },
  );
}

/// Long presses the widget found with the given control key, for the given duration
StepDefinitionGeneric whenLongPressWidgetForDuration() {
  return when2<String, int, FlutterWorld>(
    RegExp(
        r'I long press the {string} (?:button|element|label|icon|field|text|widget) for {int} milliseconds$'),
    (key, milliseconds, context) async {
      final finder = context.world.appDriver.findBy(key, FindType.key);

      await context.world.appDriver.scrollIntoView(
        finder,
      );
      await context.world.appDriver.longPress(
        finder,
        pressDuration: Duration(milliseconds: milliseconds),
      );
    },
  );
}
