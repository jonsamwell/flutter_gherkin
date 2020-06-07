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
class TextExistsStep extends When2WithWorld<String, Existence, FlutterWorld> {
  @override
  Future<void> executeStep(String text, Existence exists) async {
    if (exists == Existence.present) {
      final isPresent = await FlutterDriverUtils.isPresent(
        world.driver,
        find.text(text),
        timeout: timeout,
      );

      expect(isPresent, true);
    } else {
      final isAbsent = await FlutterDriverUtils.isAbsent(
        world.driver,
        find.text(text),
        timeout: timeout,
      );
      expect(isAbsent, true);
    }
  }

  @override
  RegExp get pattern => RegExp(r'I expect the text {string} to be {existence}$');
}
