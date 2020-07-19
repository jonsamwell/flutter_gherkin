import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/utils/driver_utils.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

/// Opens the applications main drawer
///
/// Examples:
///
///   `Given I open the drawer`
StepDefinitionGeneric GivenOpenDrawer() {
  return given1<String, FlutterWorld>(
    RegExp(r'I (open|close) the drawer'),
    (action, context) async {
      final drawerFinder = find.byType('Drawer');
      final isOpen = await FlutterDriverUtils.isPresent(
          context.world.driver, drawerFinder);
      // https://github.com/flutter/flutter/issues/9002#issuecomment-293660833
      if (isOpen && action == 'close') {
        // Swipe to the left across the whole app to close the drawer
        await context.world.driver.scroll(
            drawerFinder, -300.0, 0.0, const Duration(milliseconds: 300));
      } else if (!isOpen && action == 'open') {
        await FlutterDriverUtils.tap(
          context.world.driver,
          find.byTooltip('Open navigation menu'),
          timeout: context.configuration?.timeout,
        );
      }
    },
  );
}
