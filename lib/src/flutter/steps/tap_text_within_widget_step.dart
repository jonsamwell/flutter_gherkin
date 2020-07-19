import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget that contains the text within another widget.
/// If the text is not visible, the ancestor will be scrolled.
///
/// Examples:
///
///   `Then I tap the label that contains the text "Logout" within the "user_settings_list"`
StepDefinitionGeneric TapTextWithinWidgetStep() {
  return given2<String, String, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|field|text|widget) that contains the text {string} within the {string}'),
    (text, ancestorKey, context) async {
      final timeout =
          context.configuration?.timeout ?? const Duration(seconds: 20);
      final finder = find.descendant(
        of: find.byValueKey(ancestorKey),
        matching: find.text(text),
        firstMatchOnly: true,
      );

      final isPresent = await FlutterDriverUtils.isPresent(
        context.world.driver,
        finder,
        timeout: timeout * .2,
      );

      if (!isPresent) {
        await context.world.driver.scrollUntilVisible(
          find.byValueKey(ancestorKey),
          find.text(text),
          dyScroll: -100.0,
          timeout: timeout * .9,
        );
      }

      await FlutterDriverUtils.tap(
        context.world.driver,
        finder,
        timeout: timeout,
      );
    },
  );
}
