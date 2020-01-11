import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

/// Expects a widget with the given key to be present within 5 seconds
///
/// Parameters:
///   1 - {string} the control key
///
/// Examples:
///
///   `Then I expect the widget 'notification' to be present`
///   `Then I expect the button 'save' to be present`
class ThenExpectWidgetToBePresent extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(
      r"I expect the [button|element|label|icon|field|text|widget] {string} to be present");

  @override
  Future<void> executeStep(String key) async {
    await FlutterDriverUtils.isPresent(
      find.byValueKey(key),
      world.driver,
      timeout: const Duration(seconds: 5),
    );
  }
}
