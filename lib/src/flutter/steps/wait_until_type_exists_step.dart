import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

import '../parameters/existence_parameter.dart';

/// Waits until a widget type is present or absent.
///
/// Examples:
///
///   `Then I wait until the element of type "ProgressIndicator" is absent`
///   `And I wait until the button of type the "MaterialButton" is present`
StepDefinitionGeneric WaitUntilTypeExistsStep() {
  return then2<String, Existence, FlutterWorld>(
    'I wait until the (?:button|element|label|icon|field|text|widget) of type {string} is {existence}',
    (ofType, existence, context) async {
      await FlutterDriverUtils.waitUntil(
        context.world.driver,
        () {
          return existence == Existence.absent
              ? FlutterDriverUtils.isAbsent(
                  context.world.driver,
                  find.byType(ofType),
                )
              : FlutterDriverUtils.isPresent(
                  context.world.driver,
                  find.byType(ofType),
                );
        },
      );
    },
  );
}
