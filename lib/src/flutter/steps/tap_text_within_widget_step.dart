import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget that contains the text within another widget.
/// If the text is not visible, the ancestor will be scrolled.
///
/// Examples:
///
///   `Then I tap the label that contains the text "Logout" within the "user_settings_list"`
StepDefinitionGeneric tapTextWithinWidgetStep() {
  return given2<String, String, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|field|text|widget) that contains the text {string} within the {string}'),
    (text, ancestorKey, context) async {
      final timeout =
          context.configuration.timeout ?? const Duration(seconds: 20);
      final finder = context.world.appDriver.findByDescendant(
        context.world.appDriver.findBy(ancestorKey, FindType.key),
        context.world.appDriver.findBy(text, FindType.text),
        firstMatchOnly: true,
      );

      final isPresent = await context.world.appDriver.isPresent(
        finder,
        timeout: timeout * .2,
      );

      if (!isPresent) {
        await context.world.appDriver.scrollUntilVisible(
          context.world.appDriver.findByDescendant(
            context.world.appDriver.findBy(ancestorKey, FindType.key),
            context.world.appDriver.findBy(text, FindType.text),
          ),
          dy: -100.0,
          timeout: timeout * .9,
        );
      }

      await context.world.appDriver.tap(
        finder,
        timeout: timeout,
      );
    },
  );
}
