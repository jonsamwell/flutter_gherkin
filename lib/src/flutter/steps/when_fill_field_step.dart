import 'package:flutter_gherkin/src/flutter/adapters/app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Enters the given text into the widget with the key provided
///
/// Examples:
///   Then I fill the "email" field with "bob@gmail.com"
///   Then I fill the "name" field with "Woody Johnson"
StepDefinitionGeneric whenFillFieldStep() {
  return given2<String, String, FlutterWorld>(
    'I fill the {string} field with {string}',
    (key, value, context) async {
      final finder = context.world.appDriver.findBy(key, FindType.key);
      await context.world.appDriver.scrollIntoView(finder);
      await context.world.appDriver.enterText(
        finder,
        value,
      );
    },
  );
}
