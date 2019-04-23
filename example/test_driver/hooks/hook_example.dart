import 'package:gherkin/gherkin.dart';

class HookExample extends Hook {
  /// The priority to assign to this hook.
  /// Higher priority gets run first so a priority of 10 is run before a priority of 2
  @override
  int get priority => 1;

  /// Run before any scenario in a test run have executed
  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    print("before run hook");
  }

  /// Run after all scenarios in a test run have completed
  @override
  Future<void> onAfterRun(TestConfiguration config) async {
    print("after run hook");
  }

  /// Run before a scenario and it steps are executed
  @override
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario) async {
    print("running hook before scenario '$scenario'");
  }

  /// Run after a scenario has executed
  @override
  Future<void> onAfterScenario(
      TestConfiguration config, String scenario) async {
    print("running hook after scenario '$scenario'");
  }
}
