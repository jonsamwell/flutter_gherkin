import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget of type.
///
/// Examples:
///
///   `Then I tap the element of type "MaterialButton"`
///   `Then I tap the label of type "ListTile"`
///   `Then I tap the field of type "TextField"`
StepDefinitionGeneric tapWidgetOfTypeStep() {
  return given1<String, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|icon|field|text|widget) of type {string}$'),
    (input1, context) async {
      await context.world.appDriver.tap(
        context.world.appDriver.findBy(
          input1,
          FindType.type,
        ),
      );
    },
  );
}
