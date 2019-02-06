import 'package:flutter_gherkin/flutter_gherkin.dart';

/// A hook that is run during certain points in the execution cycle
/// You can override any or none of the methods
abstract class Hook {
  /// The priority to assign to this hook.
  /// Higher priority gets run first so a priority of 10 is run before a priority of 2
  int get priority => 0;

  /// Run before any scenario in a test run have executed
  Future<void> onBeforeRun(TestConfiguration config) => Future.value(null);

  /// Run after all scenarios in a test run have completed
  Future<void> onAfterRun(TestConfiguration config) => Future.value(null);

  /// Run after the scenario world is created but run before a scenario and its steps are executed
  /// Might not be invoked if there is not a world object
  Future<void> onAfterScenarioWorldCreated(World world, String scenario) =>
          Future.value(null);

  /// Run before a scenario and it steps are executed
  Future<void> onBeforeScenario(TestConfiguration config, String scenario) =>
      Future.value(null);

  /// Run after a scenario has executed
  Future<void> onAfterScenario(TestConfiguration config, String scenario) =>
      Future.value(null);
}
