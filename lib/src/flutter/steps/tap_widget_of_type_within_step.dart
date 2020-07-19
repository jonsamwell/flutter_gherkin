import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget of type within another widget.
///
/// Examples:
///
///   `Then I tap the element of type "MaterialButton" within the "user_settings_list"`
StepDefinitionGeneric TapWidgetOfTypeWithinStep() {
  return when2<String, String, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|icon|field|text|widget) of type {string} within the {string}$'),
    (widgetType, ancestorKey, context) async {
      final finder = find.descendant(
        of: find.byValueKey(ancestorKey),
        matching: find.byType(widgetType),
        firstMatchOnly: true,
      );
      await FlutterDriverUtils.tap(
        context.world.driver,
        finder,
      );
    },
  );
}
