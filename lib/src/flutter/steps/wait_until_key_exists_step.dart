import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

import '../parameters/existence_parameter.dart';

/// Waits until a widget is present or absent.
///
/// Examples:
///
///   `Then I wait until the "login_loading_indicator" is absent`
///   `And I wait until the "login_screen" is present`
StepDefinitionGeneric WaitUntilKeyExistsStep() {
  return then2<String, Existence, FlutterWorld>(
    'I wait until the {string} is {existence}',
    (keyString, existence, context) async {
      await FlutterDriverUtils.waitUntil(
        context.world.driver,
        () {
          return existence == Existence.absent
              ? FlutterDriverUtils.isAbsent(
                  context.world.driver,
                  find.byValueKey(keyString),
                )
              : FlutterDriverUtils.isPresent(
                  context.world.driver,
                  find.byValueKey(keyString),
                );
        },
      );
    },
  );
}
