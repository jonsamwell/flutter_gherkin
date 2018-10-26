import 'package:flutter_gherkin/flutter_gherkin.dart';

typedef void OnBeforeRunCode();

class HookMock extends Hook {
  int onBeforeRunInvocationCount = 0;
  int onAfterRunInvocationCount = 0;
  int onBeforeScenarioInvocationCount = 0;
  int onAfterScenarioInvocationCount = 0;

  final int providedPriority;
  final OnBeforeRunCode onBeforeRunCode;

  @override
  int get priority => providedPriority;

  HookMock({this.onBeforeRunCode, this.providedPriority = 0});

  Future<void> onBeforeRun(TestConfiguration config) async {
    onBeforeRunInvocationCount += 1;
    if (onBeforeRunCode != null) {
      onBeforeRunCode();
    }
  }

  Future<void> onAfterRun(TestConfiguration config) async =>
      onAfterRunInvocationCount += 1;

  Future<void> onBeforeScenario(
          TestConfiguration config, String scenario) async =>
      onBeforeScenarioInvocationCount += 1;

  Future<void> onAfterScenario(
          TestConfiguration config, String scenario) async =>
      onAfterScenarioInvocationCount += 1;
}
