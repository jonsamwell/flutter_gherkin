import 'package:flutter_gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition_implementations.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_functions.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';

abstract class And extends StepDefinition<World> {
  And([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class AndWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  AndWithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
  @override
  StepDefinitionCode get code => () async => await executeStep();

  Future<void> executeStep();
}

abstract class And1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  And1WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
  @override
  StepDefinitionCode1<TInput1> get code => (a) async => await executeStep(a);

  Future<void> executeStep(TInput1 input1);
}

abstract class And1<TInput1> extends And1WithWorld<TInput1, World> {
  And1([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class And2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  And2WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode2<TInput1, TInput2> get code =>
      (a, b) async => await executeStep(a, b);

  Future<void> executeStep(TInput1 input1, TInput2 input2);
}

abstract class And2<TInput1, TInput2>
    extends And2WithWorld<TInput1, TInput2, World> {
  And2([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class And3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  And3WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode3<TInput1, TInput2, TInput3> get code =>
      (a, b, c) async => await executeStep(a, b, c);

  Future<void> executeStep(TInput1 input1, TInput2 input2, TInput3 input3);
}

abstract class And3<TInput1, TInput2, TInput3>
    extends And3WithWorld<TInput1, TInput2, TInput3, World> {
  And3([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class And4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  And4WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode4<TInput1, TInput2, TInput3, TInput4> get code =>
      (a, b, c, d) async => await executeStep(a, b, c, d);

  Future<void> executeStep(
      TInput1 input1, TInput2 input2, TInput3 input3, TInput4 input4);
}

abstract class And4<TInput1, TInput2, TInput3, TInput4>
    extends And4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  And4([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class And5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  And5WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode5<TInput1, TInput2, TInput3, TInput4, TInput5> get code =>
      (a, b, c, d, e) async => await executeStep(a, b, c, d, e);

  Future<void> executeStep(TInput1 input1, TInput2 input2, TInput3 input3,
      TInput4 input4, TInput5 input5);
}

abstract class And5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends And5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  And5([StepDefinitionConfiguration configuration]) : super(configuration);
}
