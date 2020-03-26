import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

/// Opens the applications main drawer
///
/// Examples:
///
///   `Given I open the drawer`
class GivenOpenDrawer extends Given1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I (open|close) the drawer");

  @override
  Future<void> executeStep(String action) async {
    final drawerFinder = find.byType("Drawer");
    final isOpen =
        await FlutterDriverUtils.isPresent(world.driver, drawerFinder);
    // https://github.com/flutter/flutter/issues/9002#issuecomment-293660833
    if (isOpen && action == "close") {
      // Swipe to the left across the whole app to close the drawer
      await world.driver
          .scroll(drawerFinder, -300.0, 0.0, const Duration(milliseconds: 300));
    } else if (!isOpen && action == "open") {
      await FlutterDriverUtils.tap(
        world.driver,
        find.byTooltip("Open navigation menu"),
        timeout: timeout,
      );
    }
  }
}
