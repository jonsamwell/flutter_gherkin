import 'package:flutter_gherkin/src/gherkin/expressions/gherkin_expression.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';

class ExectuableStep {
  final GherkinExpression expression;
  final StepDefinitionGeneric<World> step;

  ExectuableStep(this.expression, this.step);
}
