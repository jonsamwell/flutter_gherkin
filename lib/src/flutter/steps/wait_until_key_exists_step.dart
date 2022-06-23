import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../parameters/existence_parameter.dart';

/// Waits until a widget is present or absent.
///
/// Examples:
///
///   `Then I wait until the "login_loading_indicator" is absent`
///   `And I wait until the "login_screen" is present`
StepDefinitionGeneric waitUntilKeyExistsStep() {
  return then2<String, Existence, FlutterWorld>(
    'I wait until the {string} is {existence}',
    (keyString, existence, context) async {
      await context.world.appDriver.waitUntil(
        () async {
          await context.world.appDriver.waitForAppToSettle();

          return existence == Existence.absent
              ? context.world.appDriver.isAbsent(
                  context.world.appDriver.findBy(keyString, FindType.key),
                )
              : context.world.appDriver.isPresent(
                  context.world.appDriver.findBy(keyString, FindType.key),
                );
        },
      );
    },
  );
}
