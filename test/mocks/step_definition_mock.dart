import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition_implementations.dart';

typedef Future<void> OnRunCode(Iterable parameters);

class MockStepDefinition extends StepDefinitionBase<World, Function> {
  bool hasRun = false;
  int runCount = 0;
  final OnRunCode code;

  MockStepDefinition([this.code, int expectedParameterCount = 0]) : super(null, expectedParameterCount);

  @override
  Future<void> onRun(Iterable parameters) async {
    hasRun = true;
    runCount += 1;
    if (code != null) {
      await code(parameters);
    }
  }

  @override
  RegExp get pattern => null;
}
