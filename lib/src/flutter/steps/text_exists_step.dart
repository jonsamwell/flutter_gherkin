import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../parameters/existence_parameter.dart';

/// Asserts the existence of text on the screen.
///
/// Examples:
///
///   `Then I expect the text "Logout" to be present`
///   `But I expect the text "Signup" to be absent`
StepDefinitionGeneric TextExistsStep() {
  return then2<String, Existence, FlutterWorld>(
    RegExp(r'I expect the text {string} to be {existence}$'),
    (text, exists, context) async {
      if (exists == Existence.present) {
        final isPresent = await FlutterDriverUtils.isPresent(
          context.world.driver,
          find.text(text),
        );

        context.expect(isPresent, true);
      } else {
        final isAbsent = await FlutterDriverUtils.isAbsent(
          context.world.driver,
          find.text(text),
        );
        context.expect(isAbsent, true);
      }
    },
  );
}
