import 'dart:collection';
import 'package:flutter_gherkin/src/gherkin/exceptions/syntax_error.dart';

/// Evaluates tag expression lexicon such as
/// @smoke and @perf
/// @smoke and not @perf
/// not @smoke and not @perf
/// not (@smoke or @perf)
/// @smoke and (@perf or @android)
/// see https://docs.cucumber.io/cucumber/tag-expressions/
///
/// We can tackle these infix expressions with good old reverse polish notation
/// which incidently was one of the first algorithms I coded when I got my first
/// programing job.
class TagExpressionEvaluator {
  static const String openingBracket = "(";
  static const String closingBracket = ")";
  static final Map<String, int> _operatorPrededence = {
    "not": 4,
    "or": 2,
    "and": 2,
    "(": 0,
  };

  bool evaluate(String tagExpression, List<String> tags) {
    bool match = true;
    final rpn = _convertInfixToPostfixExpression(tagExpression);
    match = _evaluateRpn(rpn, tags);
    return match;
  }

  bool _evaluateRpn(Queue<String> rpn, List<String> tags) {
    final Queue<bool> stack = Queue<bool>();
    for (var token in rpn) {
      if (_isTag(token)) {
        stack.addFirst(tags.contains(token.replaceFirst(RegExp("@"), "")));
      } else {
        switch (token) {
          case "and":
            {
              final a = stack.removeFirst();
              final b = stack.removeFirst();
              stack.addFirst(a && b);
              break;
            }
          case "or":
            {
              final a = stack.removeFirst();
              final b = stack.removeFirst();
              stack.addFirst(a || b);
              break;
            }
          case "not":
            {
              final a = stack.removeFirst();
              stack.addFirst(!a);
              break;
            }
        }
      }
    }

    return stack.removeFirst();
  }

  Queue<String> _convertInfixToPostfixExpression(String infixExpression) {
    final expressionParts = RegExp(
            r"(\()|(or)|(and)|(not)|(@{1}\w{1}[^\s&\)]*)|(\))",
            caseSensitive: false)
        .allMatches(infixExpression)
        .map((m) => m.group(0));
    final rpn = Queue<String>();
    final operatorQueue = ListQueue();

    for (var part in expressionParts) {
      if (_isTag(part)) {
        rpn.add(part);
      } else if (part == openingBracket) {
        operatorQueue.addLast(part);
      } else if (part == closingBracket) {
        while (
            operatorQueue.isNotEmpty && operatorQueue.last != openingBracket) {
          rpn.add(operatorQueue.removeLast());
        }
        operatorQueue.removeLast();
      } else if (_isOperator(part)) {
        final precendence = _operatorPrededence[part.toLowerCase()];

        while (operatorQueue.isNotEmpty &&
            _operatorPrededence[operatorQueue.last] >= precendence) {
          rpn.add(operatorQueue.removeLast());
        }
        operatorQueue.addLast(part);
      } else {
        throw GherkinSyntaxException(
            "Tag expression '$infixExpression' is not valid.  Unknown token '$part'. Known tokens are '@tag', 'and', 'or', 'not' '(' and ')'");
      }
    }

    while (operatorQueue.isNotEmpty) {
      rpn.add(operatorQueue.removeLast());
    }

    return rpn;
  }

  bool _isTag(String token) =>
      RegExp(r"^@\w{1}.*", caseSensitive: false).hasMatch(token);

  bool _isOperator(String token) {
    switch (token.toLowerCase()) {
      case "and":
      case "or":
      case "not":
      case openingBracket:
        return true;
      default:
        return false;
    }
  }
}
