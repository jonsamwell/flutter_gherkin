import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../parameters/existence_parameter.dart';

/// Waits until a widget type is present or absent.
///
/// Examples:
///
///   `Then I wait until the element of type "ProgressIndicator" is absent`
///   `And I wait until the button of type the "MaterialButton" is present`
StepDefinitionGeneric waitUntilTypeExistsStep() {
  return then2<String, Existence, FlutterWorld>(
    'I wait until the (?:button|element|label|icon|field|text|widget) of type {string} is {existence}',
    (ofType, existence, context) async {
      await context.world.appDriver.waitUntil(
        () async {
          await context.world.appDriver.waitForAppToSettle();

          return existence == Existence.absent
              ? context.world.appDriver.isAbsent(
                  context.world.appDriver.findBy(ofType, FindType.type),
                )
              : context.world.appDriver.isPresent(
                  context.world.appDriver.findBy(ofType, FindType.type),
                );
        },
      );
    },
  );
}
