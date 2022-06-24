import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Taps the back button widget
///
/// Examples:
///
///   `When I tap the back button"`
///   `When I tap the back element"`
///   `When I tap the back widget"`
StepDefinitionGeneric whenTapBackButtonWidget() {
  return when<FlutterWorld>(
    RegExp(r'I tap the back (?:button|element|widget|icon|text)$'),
    (context) async {
      await context.world.appDriver.pageBack();
    },
  );
}
