import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:gherkin/gherkin.dart';

/// Enters the given text into the widget with the key provided
///
/// Examples:
///   Then I fill the "email" field with "bob@gmail.com"
///   Then I fill the "name" field with "Woody Johnson"
StepDefinitionGeneric WhenFillFieldStep() {
  return given2<String, String, FlutterWorld>(
    'I fill the {string} field with {string}',
    (key, value, context) async {
      final finder = find.byValueKey(key);
      await context.world.driver.scrollIntoView(finder);
      await FlutterDriverUtils.enterText(
        context.world.driver,
        finder,
        value,
      );
    },
  );
}
