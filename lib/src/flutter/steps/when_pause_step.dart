import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Pauses the execution for the provided number of seconds.
/// Handy when you want to pause to check something.
/// Note: this should only be used during development as having to pause during a test usually indicates timing issues
///
/// Examples:
///   When I pause for 10 seconds
///   When I pause for 120 seconds
StepDefinitionGeneric whenPauseStep() {
  return when1<int, FlutterWorld>(
    'I (?:pause|wait) for {int} second(?:s)?',
    (wait, context) async {
      await Future.delayed(Duration(seconds: wait));
      await context.world.appDriver.waitForAppToSettle();
    },
    configuration: StepDefinitionConfiguration()
      // add a large timeout here, I think 15 is more than enough
      ..timeout = const Duration(minutes: 15),
  );
}
