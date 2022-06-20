import 'package:flutter_gherkin/src/flutter/adapters/app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Expects the element found with the given control key to have the given string value.
///
/// Parameters:
///   1 - {string} the control key
///   2 - {string} the value of the control
///
/// Examples:
///
///   `Then I expect the "controlKey" to be "Hello World"`
///   `And I expect the "controlKey" to be "Hello World"`
StepDefinitionGeneric thenExpectElementToHaveValue() {
  return given2<String, String, FlutterWorld>(
    RegExp(r'I expect the {string} to be {string}$'),
    (key, value, context) async {
      try {
        final finder = context.world.appDriver.findBy(key, FindType.key);
        final text = await context.world.appDriver.getText(finder);

        context.expect(text, value);
      } catch (e) {
        // await context.reporter('Step error: $e', MessageLevel.error);
        rethrow;
      }
    },
  );
}
