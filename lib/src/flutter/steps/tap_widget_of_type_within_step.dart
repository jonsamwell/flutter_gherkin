import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget of type within another widget.
///
/// Examples:
///
///   `Then I tap the element of type "MaterialButton" within the "user_settings_list"`
StepDefinitionGeneric tapWidgetOfTypeWithinStep() {
  return when2<String, String, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|icon|field|text|widget) of type {string} within the {string}$'),
    (widgetType, ancestorKey, context) async {
      final finder = context.world.appDriver.findByDescendant(
        context.world.appDriver.findBy(ancestorKey, FindType.key),
        context.world.appDriver.findBy(widgetType, FindType.type),
        firstMatchOnly: true,
      );
      await context.world.appDriver.tap(finder);
    },
  );
}
