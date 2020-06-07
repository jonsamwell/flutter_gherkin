import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../parameters/existence_parameter.dart';

/// Asserts the existence of text within a parent widget.
///
/// Examples:
///
///   `Then I expect the text "Logout" to be present within the "user_settings_list"`
///   `But I expect the text "Signup" to be absent within the "login_screen"`
class TextExistsWithinStep extends When3WithWorld<String, Existence, String, FlutterWorld> {
  @override
  Future<void> executeStep(String text, Existence exists, String ancestorKey) async {
    final finder = find.descendant(
      of: find.byValueKey(ancestorKey),
      matching: find.text(text),
      firstMatchOnly: true,
    );

    final isPresent = await FlutterDriverUtils.isPresent(
      world.driver,
      finder,
      timeout: timeout,
    );
    expect(isPresent, exists == Existence.present);
  }

  @override
  RegExp get pattern =>
      RegExp(r'I expect the text {string} to be {existence} within the {string}$');
}
