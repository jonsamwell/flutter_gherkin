import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/configuration.dart';
import 'package:flutter_gherkin/src/hooks/hook.dart';

class AggregatedHook extends Hook {
  Iterable<Hook> _orderedHooks;

  void addHooks(Iterable<Hook> hooks) {
    _orderedHooks = hooks.toList()..sort((a, b) => b.priority - a.priority);
  }

  Future<void> onBeforeRun(TestConfiguration config) async =>
      await _invokeHooks((h) => h.onBeforeRun(config));

  /// Run after all scenerios in a test run have completed
  Future<void> onAfterRun(TestConfiguration config) async =>
      await _invokeHooks((h) => h.onAfterRun(config));

  Future<void> onAfterScenarioWorldCreated(
          World world, String scenario) async =>
      await _invokeHooks((h) => h.onAfterScenarioWorldCreated(world, scenario));

  /// Run before a scenario and it steps are executed
  Future<void> onBeforeScenario(
          TestConfiguration config, String scenario) async =>
      await _invokeHooks((h) => h.onBeforeScenario(config, scenario));

  /// Run after a scenario has executed
  Future<void> onAfterScenario(
          TestConfiguration config, String scenario) async =>
      await _invokeHooks((h) => h.onAfterScenario(config, scenario));

  Future<void> _invokeHooks(Future<void> invoke(Hook h)) async {
    if (_orderedHooks != null && _orderedHooks.length > 0) {
      for (var hook in _orderedHooks) {
        await invoke(hook);
      }
    }
  }
}
