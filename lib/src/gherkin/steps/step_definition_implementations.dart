import 'package:flutter_gherkin/src/expect/expect_mimic.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_functions.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';

abstract class StepDefinitionBase<TWorld extends World,
        TStepDefinitionCode extends Function>
    extends StepDefinitionGeneric<TWorld> {
  TStepDefinitionCode get code;

  StepDefinitionBase(
      StepDefinitionConfiguration config, int expectParameterCount)
      : super(config, expectParameterCount);

  void expect(actual, matcher, {String reason}) =>
      ExpectMimic().expect(actual, matcher, reason: reason);

  void expectA(actual, matcher, {String reason}) =>
      ExpectMimic().expect(actual, matcher, reason: reason);

  void expectMatch(actual, matcher, {String reason}) =>
      expect(actual, matcher, reason: reason);
}

abstract class StepDefinition<TWorld extends World>
    extends StepDefinitionBase<TWorld, StepDefinitionCode> {
  StepDefinition([StepDefinitionConfiguration configuration])
      : super(configuration, 0);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) async => await code();
}

abstract class StepDefinition1<TWorld extends World, TInput1>
    extends StepDefinitionBase<TWorld, StepDefinitionCode1<TInput1>> {
  StepDefinition1([StepDefinitionConfiguration configuration])
      : super(configuration, 1);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) async =>
      await code(parameters.elementAt(0));
}

abstract class StepDefinition2<TWorld extends World, TInput1, TInput2>
    extends StepDefinitionBase<TWorld, StepDefinitionCode2<TInput1, TInput2>> {
  StepDefinition2([StepDefinitionConfiguration configuration])
      : super(configuration, 2);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) async =>
      await code(parameters.elementAt(0), parameters.elementAt(1));
}

abstract class StepDefinition3<TWorld extends World, TInput1, TInput2, TInput3>
    extends StepDefinitionBase<TWorld,
        StepDefinitionCode3<TInput1, TInput2, TInput3>> {
  StepDefinition3([StepDefinitionConfiguration configuration])
      : super(configuration, 3);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) async => await code(
      parameters.elementAt(0),
      parameters.elementAt(1),
      parameters.elementAt(2));
}

abstract class StepDefinition4<TWorld extends World, TInput1, TInput2, TInput3,
        TInput4>
    extends StepDefinitionBase<TWorld,
        StepDefinitionCode4<TInput1, TInput2, TInput3, TInput4>> {
  StepDefinition4([StepDefinitionConfiguration configuration])
      : super(configuration, 4);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) async => await code(
      parameters.elementAt(0),
      parameters.elementAt(1),
      parameters.elementAt(2),
      parameters.elementAt(3));
}

abstract class StepDefinition5<TWorld extends World, TInput1, TInput2, TInput3,
        TInput4, TInput5>
    extends StepDefinitionBase<TWorld,
        StepDefinitionCode5<TInput1, TInput2, TInput3, TInput4, TInput5>> {
  StepDefinition5([StepDefinitionConfiguration configuration])
      : super(configuration, 5);

  @override
  Future<void> onRun(Iterable<dynamic> parameters) async => await code(
      parameters.elementAt(0),
      parameters.elementAt(1),
      parameters.elementAt(2),
      parameters.elementAt(3),
      parameters.elementAt(4));
}
