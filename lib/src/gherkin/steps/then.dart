import 'package:flutter_gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition_implementations.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_functions.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';

abstract class Then extends StepDefinition<World> {
  Then([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class ThenWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  ThenWithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
  @override
  StepDefinitionCode get code => () async => await executeStep();

  Future<void> executeStep();
}

abstract class Then1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  Then1WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
  @override
  StepDefinitionCode1<TInput1> get code => (a) async => await executeStep(a);

  Future<void> executeStep(TInput1 input1);
}

abstract class Then1<TInput1> extends Then1WithWorld<TInput1, World> {
  Then1([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Then2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  Then2WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode2<TInput1, TInput2> get code =>
      (a, b) async => await executeStep(a, b);

  Future<void> executeStep(TInput1 input1, TInput2 input2);
}

abstract class Then2<TInput1, TInput2>
    extends Then2WithWorld<TInput1, TInput2, World> {
  Then2([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Then3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  Then3WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode3<TInput1, TInput2, TInput3> get code =>
      (a, b, c) async => await executeStep(a, b, c);

  Future<void> executeStep(TInput1 input1, TInput2 input2, TInput3 input3);
}

abstract class Then3<TInput1, TInput2, TInput3>
    extends Then3WithWorld<TInput1, TInput2, TInput3, World> {
  Then3([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Then4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  Then4WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode4<TInput1, TInput2, TInput3, TInput4> get code =>
      (a, b, c, d) async => await executeStep(a, b, c, d);

  Future<void> executeStep(
      TInput1 input1, TInput2 input2, TInput3 input3, TInput4 input4);
}

abstract class Then4<TInput1, TInput2, TInput3, TInput4>
    extends Then4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  Then4([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Then5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  Then5WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode5<TInput1, TInput2, TInput3, TInput4, TInput5> get code =>
      (a, b, c, d, e) async => await executeStep(a, b, c, d, e);

  Future<void> executeStep(TInput1 input1, TInput2 input2, TInput3 input3,
      TInput4 input4, TInput5 input5);
}

abstract class Then5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends Then5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  Then5([StepDefinitionConfiguration configuration]) : super(configuration);
}
