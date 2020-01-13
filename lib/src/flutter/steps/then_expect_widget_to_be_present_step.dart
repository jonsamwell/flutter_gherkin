import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
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
class ThenExpectWidgetToBePresent
    extends When2WithWorld<String, int, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(
      r"I expect the (?:button|element|label|icon|field|text|widget) {string} to be present within {int} second(s)$");

  @override
  Future<void> executeStep(String key, int seconds) async {
    await FlutterDriverUtils.isPresent(
      find.byValueKey(key),
      world.driver,
      timeout: Duration(seconds: seconds),
    );
  }
}
