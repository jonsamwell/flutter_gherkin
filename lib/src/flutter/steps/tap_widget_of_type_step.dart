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
class TapWidgetOfTypeStep extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.tap(
      world.driver,
      find.byType(input1),
      timeout: timeout,
    );
  }

  @override
  RegExp get pattern => RegExp(
      r'I tap the (?:button|element|label|icon|field|text|widget) of type {string}$');
}
