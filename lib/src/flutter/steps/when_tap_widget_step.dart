import 'package:flutter_gherkin/src/flutter/adapters/app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Taps the widget found with the given control key.
///
/// Parameters:
///   1 - {string} the control key
///
/// Examples:
///
///   `When I tap "controlKey" button"`
///   `When I tap "controlKey" element"`
///   `When I tap "controlKey" label"`
///   `When I tap "controlKey" icon"`
///   `When I tap "controlKey" field"`
///   `When I tap "controlKey" text"`
///   `When I tap "controlKey" widget"`
StepDefinitionGeneric whenTapWidget() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I tap the {string} (?:button|element|label|icon|field|text|widget)$'),
    (key, context) async {
      final finder = context.world.appDriver.findBy(key, FindType.key);

      await context.world.appDriver.scrollIntoView(
        finder,
      );
      await context.world.appDriver.tap(
        finder,
        timeout: context.configuration.timeout,
      );
    },
  );
}

StepDefinitionGeneric whenTapWidgetWithoutScroll() {
  return when1<String, FlutterWorld>(
    RegExp(
        r'I tap the {string} (?:button|element|label|icon|field|text|widget) without scrolling it into view$'),
    (key, context) async {
      final finder =
          context.world.appDriver.findByDescendant(key, FindType.key);

      await context.world.appDriver.tap(
        finder,
      );
    },
  );
}
