import 'package:flutter_gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition_implementations.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_functions.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';

abstract class GivenWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  GivenWithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
  @override
  StepDefinitionCode get code => () async => await executeStep();

  Future<void> executeStep();
}

abstract class Given extends GivenWithWorld<World> {
  Given([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  Given1WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
  @override
  StepDefinitionCode1<TInput1> get code => (a) async => await executeStep(a);

  Future<void> executeStep(TInput1 input1);
}

abstract class Given1<TInput1> extends Given1WithWorld<TInput1, World> {
  Given1([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  Given2WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode2<TInput1, TInput2> get code =>
      (a, b) async => await executeStep(a, b);

  Future<void> executeStep(TInput1 input1, TInput2 input2);
}

abstract class Given2<TInput1, TInput2>
    extends Given2WithWorld<TInput1, TInput2, World> {
  Given2([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  Given3WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode3<TInput1, TInput2, TInput3> get code =>
      (a, b, c) async => await executeStep(a, b, c);

  Future<void> executeStep(TInput1 input1, TInput2 input2, TInput3 input3);
}

abstract class Given3<TInput1, TInput2, TInput3>
    extends Given3WithWorld<TInput1, TInput2, TInput3, World> {
  Given3([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  Given4WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode4<TInput1, TInput2, TInput3, TInput4> get code =>
      (a, b, c, d) async => await executeStep(a, b, c, d);

  Future<void> executeStep(
      TInput1 input1, TInput2 input2, TInput3 input3, TInput4 input4);
}

abstract class Given4<TInput1, TInput2, TInput3, TInput4>
    extends Given4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  Given4([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  Given5WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);

  @override
  StepDefinitionCode5<TInput1, TInput2, TInput3, TInput4, TInput5> get code =>
      (a, b, c, d, e) async => await executeStep(a, b, c, d, e);

  Future<void> executeStep(TInput1 input1, TInput2 input2, TInput3 input3,
      TInput4 input4, TInput5 input5);
}

abstract class Given5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends Given5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        World> {
  Given5([StepDefinitionConfiguration configuration]) : super(configuration);
}
