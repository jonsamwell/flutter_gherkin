import 'package:flutter_gherkin/flutter_gherkin.dart';

class HookExample extends Hook {
  /// The priority to assign to this hook.
  /// Higher priority gets run first so a priority of 10 is run before a priority of 2
  int get priority => 1;

  @override

  /// Run before any scenario in a test run have executed
  Future<void> onBeforeRun(TestConfiguration config) async {
    print("before run hook");
  }

  @override

  /// Run after all scenarios in a test run have completed
  Future<void> onAfterRun(TestConfiguration config) async {
    print("after run hook");
  }

  @override

  /// Run before a scenario and it steps are executed
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario) async {
    print("running hook before scenario '$scenario'");
  }

  @override

  /// Run after a scenario has executed
  Future<void> onAfterScenario(
      TestConfiguration config, String scenario) async {
    print("running hook after scenario '$scenario'");
  }
}
