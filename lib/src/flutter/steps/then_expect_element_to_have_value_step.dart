import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/gherkin/steps/then.dart';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_driver/flutter_driver.dart';

/// Expects the element found with the given control key to have the given string value.
///
/// Parameters:
///   1 - {string} the control key
///   2 - {string} the value of the control
///
/// Examples:
///
///   `Then I expect "controlKey" to be "Hello World"`
///   `And I expect "controlKey" to be "Hello World"`
class ThenExpectElementToHaveValue
    extends Then2WithWorld<String, String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I expect the {string} to be {string}");

  @override
  Future<void> executeStep(String key, String value) async {
    final locator = find.byValueKey(key);
    try {
      final text = await world.driver.getText(locator, timeout: timeout);
      expect(text, value);
    } catch (e) {
      await reporter.message(
          "Step error '${pattern.pattern}': $e", MessageLevel.error);
      rethrow;
    }
  }
}
