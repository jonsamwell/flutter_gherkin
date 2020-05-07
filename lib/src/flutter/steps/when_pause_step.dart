import 'package:gherkin/gherkin.dart';

/// Pauses the execution for the provided number of seconds.
/// Handy when you want to pause to check something.
/// Note: this should only be used during development as having to pause during a test usually indicates timing issues
///
/// Examples:
///   When I pause for 10 seconds
///   When I pause for 120 seconds
class WhenPauseStep extends When1<int> {
  WhenPauseStep()
      : super(StepDefinitionConfiguration()
          ..timeout = const Duration(minutes: 5));

  @override
  Future<void> executeStep(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  @override
  RegExp get pattern => RegExp(r'I pause for {int} second(s)');
}
