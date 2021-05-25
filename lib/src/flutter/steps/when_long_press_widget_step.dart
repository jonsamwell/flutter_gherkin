import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
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
StepDefinitionGeneric WhenLongPressWidget() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I long press the {string} (?:button|element|label|icon|field|text|widget)$'),
    (key, context) async {
      final finder = find.byValueKey(key);

      await context.world.driver!.scrollIntoView(
        finder,
      );
      await FlutterDriverUtils.longPress(
        context.world.driver!,
        finder,
      );
    },
  );
}

/// Long presses the widget found with the given control key, without scrolling into view
StepDefinitionGeneric WhenLongPressWidgetWithoutScroll() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I long press the {string} (?:button|element|label|icon|field|text|widget) without scrolling it into view$'),
    (key, context) async {
      final finder = find.byValueKey(key);

      await FlutterDriverUtils.longPress(
        context.world.driver!,
        finder,
      );
    },
  );
}

/// Long presses the widget found with the given control key, for the given duration
StepDefinitionGeneric WhenLongPressWidgetForDuration() {
  return when2<String, int, FlutterWorld>(
    RegExp(
        r'I long press the {string} (?:button|element|label|icon|field|text|widget) for {int} milliseconds$'),
    (key, milliseconds, context) async {
      final finder = find.byValueKey(key);

      await context.world.driver!.scrollIntoView(
        finder,
      );
      await FlutterDriverUtils.longPress(
        context.world.driver!,
        finder,
        pressDuration: Duration(milliseconds: milliseconds),
      );
    },
  );
}
