import 'package:flutter_gherkin/src/hooks/aggregated_hook.dart';
import 'package:test/test.dart';
import '../mocks/hook_mock.dart';

void main() {
  group("orders hooks", () {
    test("executes hooks in correct order", () async {
      final executionOrder = List<int>();
      final hookOne = HookMock(
          providedPriority: 0, onBeforeRunCode: () => executionOrder.add(3));
      final hookTwo = HookMock(
          providedPriority: 10, onBeforeRunCode: () => executionOrder.add(2));
      final hookThree = HookMock(
          providedPriority: 20, onBeforeRunCode: () => executionOrder.add(1));
      final hookFour = HookMock(
          providedPriority: -1, onBeforeRunCode: () => executionOrder.add(4));

      final aggregatedHook = AggregatedHook();
      aggregatedHook.addHooks([hookOne, hookTwo, hookThree, hookFour]);
      await aggregatedHook.onBeforeRun(null);
      expect(executionOrder, [1, 2, 3, 4]);
      expect(hookOne.onBeforeRunInvocationCount, 1);
      expect(hookTwo.onBeforeRunInvocationCount, 1);
      expect(hookThree.onBeforeRunInvocationCount, 1);
      expect(hookFour.onBeforeRunInvocationCount, 1);
      await aggregatedHook.onAfterRun(null);
      expect(hookOne.onAfterRunInvocationCount, 1);
      expect(hookTwo.onAfterRunInvocationCount, 1);
      expect(hookThree.onAfterRunInvocationCount, 1);
      expect(hookFour.onAfterRunInvocationCount, 1);
      await aggregatedHook.onBeforeScenario(null, null);
      expect(hookOne.onBeforeScenarioInvocationCount, 1);
      expect(hookTwo.onBeforeScenarioInvocationCount, 1);
      expect(hookThree.onBeforeScenarioInvocationCount, 1);
      expect(hookFour.onBeforeScenarioInvocationCount, 1);
      await aggregatedHook.onAfterScenario(null, null);
      expect(hookOne.onAfterScenarioInvocationCount, 1);
      expect(hookTwo.onAfterScenarioInvocationCount, 1);
      expect(hookThree.onAfterScenarioInvocationCount, 1);
      expect(hookFour.onAfterScenarioInvocationCount, 1);
    });
  });
}
