import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget of type.
///
/// Examples:
///
///   `Then I tap the element of type "MaterialButton"`
///   `Then I tap the label of type "ListTile"`
///   `Then I tap the field of type "TextField"`
StepDefinitionGeneric TapWidgetOfTypeStep() {
  return given1<String, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|icon|field|text|widget) of type {string}$'),
    (input1, context) async {
      await FlutterDriverUtils.tap(
        context.world.driver,
        find.byType(input1),
      );
    },
  );
}
