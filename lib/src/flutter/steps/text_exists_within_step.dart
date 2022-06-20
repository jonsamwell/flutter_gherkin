import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../parameters/existence_parameter.dart';

/// Asserts the existence of text within a parent widget.
///
/// Examples:
///
///   `Then I expect the text "Logout" to be present within the "user_settings_list"`
///   `But I expect the text "Sign up" to be absent within the "login_screen"`
StepDefinitionGeneric textExistsWithinStep() {
  return then3<String, Existence, String, FlutterWorld>(
    RegExp(
        r'I expect the text {string} to be {existence} within the {string}$'),
    (text, exists, ancestorKey, context) async {
      final finder = context.world.appDriver.findByDescendant(
        context.world.appDriver.findBy(ancestorKey, FindType.key),
        context.world.appDriver.findBy(text, FindType.text),
        firstMatchOnly: true,
      );

      final isPresent = await context.world.appDriver.isPresent(
        finder,
      );

      context.expect(isPresent, exists == Existence.present);
    },
  );
}
