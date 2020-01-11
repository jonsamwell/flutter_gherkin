import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

/// Taps the back button widget
///
/// Examples:
///
///   `When I tap the back button"`
///   `When I tap the back element"`
///   `When I tap the back widget"`
class WhenTapBackButtonWidget extends WhenWithWorld<FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I tap the back [button|element|widget]");

  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
      world.driver,
      find.pageBack(),
      timeout: timeout * .9,
    );
  }
}
