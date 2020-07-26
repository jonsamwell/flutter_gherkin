import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
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
StepDefinitionGeneric ThenExpectElementToHaveValue() {
  return given2<String, String, FlutterWorld>(
    RegExp(r'I expect the {string} to be {string}$'),
    (key, value, context) async {
      try {
        final text = await FlutterDriverUtils.getText(
          context.world.driver,
          find.byValueKey(key),
        );
        context.expect(text, value);
      } catch (e) {
        await context.reporter.message('Step error: $e', MessageLevel.error);
        rethrow;
      }
    },
  );
}

class AuthenticationSteps {
  static Iterable<StepDefinitionGeneric> steps = [
    StepOne(),
    StepFive(),
  ];

  static StepDefinitionGeneric StepOne() => given(
        'some step',
        (context) async {
          // do something
        },
      );

  static StepDefinitionGeneric StepFive() => given2<String, int, FlutterWorld>(
        'step five with {string} and {int}',
        (str, value, context) async {
          // do something
        },
      );
}

class AccountSteps {
  static Iterable<StepDefinitionGeneric> steps = [
    StepOne(),
    StepFive(),
  ];

  static StepDefinitionGeneric StepOne() => given(
        'some step account step',
        (context) async {
          // do something
        },
      );

  static StepDefinitionGeneric StepFive() => given2<String, int, FlutterWorld>(
        'step five with {string} and {int}',
        (str, value, context) async {
          // do something
        },
      );
}
