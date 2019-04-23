import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:gherkin/gherkin.dart';

/// Enters the given text into the widget with the key provided
///
/// Examples:
///   Then I fill the "email" field with "bob@gmail.com"
///   Then I fill the "name" field with "Woody Johnson"
class WhenFillFieldStep extends When2WithWorld<String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String key, String input2) async {
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey(key), input2,
        timeout: timeout * .9);
  }

  @override
  RegExp get pattern => RegExp(r"I fill the {string} field with {string}");
}
