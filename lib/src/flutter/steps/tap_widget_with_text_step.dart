import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget that contains text.
///
/// Examples:
///
///   `Then I tap the label that contains the text "Logout"`
///   `Then I tap the button that contains the text "Sign up"`
///   `Then I tap the widget that contains the text "My User Profile"`
StepDefinitionGeneric tapWidgetWithTextStep() {
  return then1<String, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|field|text|widget) that contains the text {string}$'),
    (input1, context) async {
      final finder = context.world.appDriver.findBy(input1, FindType.text);
      await context.world.appDriver.scrollIntoView(finder);
      await context.world.appDriver.tap(finder);
    },
  );
}
