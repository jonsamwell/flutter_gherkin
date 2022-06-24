import 'package:flutter_gherkin/src/flutter/adapters/app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Opens the applications main drawer
///
/// Examples:
///
///   `Given I open the drawer`
StepDefinitionGeneric givenOpenDrawer() {
  return given1<String, FlutterWorld>(
    RegExp(r'I (open|close) the drawer'),
    (action, context) async {
      final drawerFinder = context.world.appDriver.findBy(
        'Drawer',
        FindType.type,
      );
      final isOpen = await context.world.appDriver.isPresent(
        drawerFinder,
      );

      // https://github.com/flutter/flutter/issues/9002#issuecomment-293660833
      if (isOpen && action == 'close') {
        // Swipe to the left across the whole app to close the drawer
        await context.world.appDriver.scroll(
          drawerFinder,
          dx: -300.0,
          dy: 0.0,
          duration: const Duration(milliseconds: 300),
        );
      } else if (!isOpen && action == 'open') {
        await context.world.appDriver.tap(
          context.world.appDriver.findBy(
            'Open navigation menu',
            FindType.tooltip,
          ),
          timeout: context.configuration.timeout,
        );
      }
    },
  );
}
