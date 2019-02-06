import 'package:flutter_gherkin/flutter_gherkin.dart';

typedef void OnBeforeRunCode();

class HookMock extends Hook {
  int onBeforeRunInvocationCount = 0;
  int onAfterRunInvocationCount = 0;
  int onBeforeScenarioInvocationCount = 0;
  int onAfterScenarioInvocationCount = 0;
  int onAfterScenarioWorldCreatedInvocationCount = 0;

  final int providedPriority;
  final OnBeforeRunCode onBeforeRunCode;

  @override
  int get priority => providedPriority;

  HookMock({this.onBeforeRunCode, this.providedPriority = 0});

  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    onBeforeRunInvocationCount += 1;
    if (onBeforeRunCode != null) {
      onBeforeRunCode();
    }
  }

  @override
  Future<void> onAfterRun(TestConfiguration config) async =>
      onAfterRunInvocationCount += 1;

  @override
  Future<void> onBeforeScenario(
          TestConfiguration config, String scenario) async =>
      onBeforeScenarioInvocationCount += 1;

  @override
  Future<void> onAfterScenario(
          TestConfiguration config, String scenario) async =>
      onAfterScenarioInvocationCount += 1;

  @override
  Future<void> onAfterScenarioWorldCreated(
          World world, String scenario) async =>
      onAfterScenarioWorldCreatedInvocationCount += 1;
}
