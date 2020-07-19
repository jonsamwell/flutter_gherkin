import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

/// Taps the back button widget
///
/// Examples:
///
///   `When I tap the back button"`
///   `When I tap the back element"`
///   `When I tap the back widget"`
StepDefinitionGeneric WhenTapBackButtonWidget() {
  return when1<String, FlutterWorld>(
    RegExp(r'I tap the back (?:button|element|widget|icon|text)$'),
    (_, context) async {
      await FlutterDriverUtils.tap(
        context.world.driver,
        find.pageBack(),
      );
    },
  );
}
