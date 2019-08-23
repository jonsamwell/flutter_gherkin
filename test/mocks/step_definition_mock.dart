import 'package:gherkin/gherkin.dart';

typedef Future<void> OnRunCode(Iterable parameters);

class MockStepDefinition extends StepDefinitionBase<World> {
  bool hasRun = false;
  int runCount = 0;
  final OnRunCode code;

  MockStepDefinition([this.code, int expectedParameterCount = 0])
      : super(null, expectedParameterCount);

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
