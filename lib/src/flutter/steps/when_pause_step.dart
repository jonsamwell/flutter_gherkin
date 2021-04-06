import 'package:gherkin/gherkin.dart';

/// Pauses the execution for the provided number of seconds.
/// Handy when you want to pause to check something.
/// Note: this should only be used during development as having to pause during a test usually indicates timing issues
///
/// Examples:
///   When I pause for 10 seconds
///   When I pause for 120 seconds
StepDefinitionGeneric WhenPauseStep() {
  return when1(
    'I pause for {int} second(s)',
    (int wait, _) async {
      await Future.delayed(Duration(seconds: wait));
    },
  );
}
