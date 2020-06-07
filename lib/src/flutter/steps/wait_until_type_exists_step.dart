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
class WaitUntilTypeExistsStep extends When2WithWorld<String, Existence, FlutterWorld> {
  @override
  Future<void> executeStep(String ofType, Existence existence) async {
    await FlutterDriverUtils.waitUntil(
      world.driver,
      () {
        return existence == Existence.absent
            ? FlutterDriverUtils.isAbsent(world.driver, find.byType(ofType))
            : FlutterDriverUtils.isPresent(world.driver, find.byType(ofType));
      },
      timeout: timeout,
    );
  }

  @override
  RegExp get pattern => RegExp(
      r'I wait until the (?:button|element|label|icon|field|text|widget) of type {string} is {existence}');
}
