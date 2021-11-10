import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

/// Taps the widget found with the given control key.
///
/// Parameters:
///   1 - {string} the control key
///
/// Examples:
///
///   `When I tap the "controlKey" button"`
///   `When I tap the "controlKey" element"`
///   `When I tap the "controlKey" label"`
///   `When I tap the "controlKey" icon"`
///   `When I tap the "controlKey" field"`
///   `When I tap the "controlKey" text"`
///   `When I tap the "controlKey" widget"`
StepDefinitionGeneric WhenTapWidget() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I tap the {string} (?:button|element|label|icon|field|text|widget)$'),
    (key, context) async {
      final finder = find.byValueKey(key);

      await context.world.driver?.scrollIntoView(
        finder,
      );
      await FlutterDriverUtils.tap(
        context.world.driver,
        finder,
      );
    },
  );
}

StepDefinitionGeneric WhenTapWidgetWithoutScroll() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I tap the {string} (?:button|element|label|icon|field|text|widget) without scrolling it into view$'),
    (key, context) async {
      final finder = find.byValueKey(key);

      await FlutterDriverUtils.tap(
        context.world.driver,
        finder,
      );
    },
  );
}
