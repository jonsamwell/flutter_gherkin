import 'package:flutter_gherkin/src/gherkin/expressions/gherkin_expression.dart';

typedef bool IsMatchFn(String input);

class MockGherkinExpression implements GherkinExpression {
  final IsMatchFn isMatchFn;

  MockGherkinExpression(this.isMatchFn);

  @override
  Iterable getParameters(String input) => const Iterable.empty();

  @override
  bool isMatch(String input) => isMatchFn(input);

  @override
  RegExp get originalExpression => null;
}
