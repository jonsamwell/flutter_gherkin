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
///   `When I tap "controlKey" button"`
///   `When I tap "controlKey" element"`
///   `When I tap "controlKey" label"`
///   `When I tap "controlKey" icon"`
///   `When I tap "controlKey" field"`
///   `When I tap "controlKey" text"`
///   `When I tap "controlKey" widget"`
class WhenTapWidget extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(
      r"I tap the {string} (?:button|element|label|icon|field|text|widget)$");

  @override
  Future<void> executeStep(String key) async {
    final finder = find.byValueKey(key);

    await world.driver.scrollIntoView(
      finder,
      timeout: timeout * .45,
    );
    await FlutterDriverUtils.tap(
      world.driver,
      finder,
      timeout: timeout * .45,
    );
  }
}
