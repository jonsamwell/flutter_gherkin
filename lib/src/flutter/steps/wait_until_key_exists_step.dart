import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

import '../parameters/existence_parameter.dart';

/// Waits until a widget is present or absent.
///
/// Examples:
///
///   `Then I wait until the "login_loading_indicator" is absent`
///   `And I wait until the "login_screen" is present`
class WaitUntilKeyExistsStep
    extends When2WithWorld<String, Existence, FlutterWorld> {
  @override
  Future<void> executeStep(String keyString, Existence existence) async {
    await FlutterDriverUtils.waitUntil(
      world.driver,
      () {
        return existence == Existence.absent
            ? FlutterDriverUtils.isAbsent(
                world.driver, find.byValueKey(keyString))
            : FlutterDriverUtils.isPresent(
                world.driver, find.byValueKey(keyString));
      },
      timeout: timeout,
    );
  }

  @override
  RegExp get pattern => RegExp(r'I wait until the {string} is {existence}');
}
