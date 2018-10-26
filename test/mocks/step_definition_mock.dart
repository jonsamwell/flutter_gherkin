import 'package:flutter_gherkin/flutter_gherkin.dart';

typedef Future<void> OnRunCode(Iterable parameters);

class MockStepDefinition extends StepDefinitionGeneric<World> {
  bool hasRun = false;
  int runCount = 0;
  final OnRunCode code;

  MockStepDefinition([this.code]) : super(null, 0);

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
