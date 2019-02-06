import "package:flutter_gherkin/src/gherkin/expressions/tag_expression.dart";
import "package:test/test.dart";

void main() {
  group("TagExpression", () {
    test("evaluate simple single tag expression correctly", () async {
      final evaluator = TagExpressionEvaluator();
      final tags = ["a", "b", "c"];

      expect(evaluator.evaluate("@a", tags), true);
      expect(evaluator.evaluate("@b", tags), true);
      expect(evaluator.evaluate("@d", tags), false);
    });

    test("evaluate complex and tag expression correctly", () async {
      final evaluator = TagExpressionEvaluator();
      final tags = ["a", "b", "c"];

      expect(evaluator.evaluate("@a and @d", tags), false);
      expect(evaluator.evaluate("(@a and not @d)", tags), true);
      expect(evaluator.evaluate("(@a and not @c)", tags), false);
    });

    test("evaluate complex or tag expression correctly", () async {
      final evaluator = TagExpressionEvaluator();
      final tags = ["a", "b", "c"];

      expect(evaluator.evaluate("(@a or @b)", tags), true);
      expect(evaluator.evaluate("not @a or not @d", tags), true);
      expect(evaluator.evaluate("not @d or not @e", tags), true);
    });

    test("evaluate complex bracket tag expression correctly", () async {
      final evaluator = TagExpressionEvaluator();
      final tags = ["a", "b", "c"];

      expect(evaluator.evaluate("@a or (@b and @c)", tags), true);
      expect(evaluator.evaluate("@a and (@d or @e)", tags), false);
      expect(evaluator.evaluate("@a and ((@b or not @e) or (@b and @c))", tags),
          true);
      expect(
          evaluator.evaluate(
              "@a and ((@b and not @e) and (@b and @c))", ["a", "b", "c", "e"]),
          false);
      expect(
          evaluator.evaluate("@a and ((@b or not @e) and (@b and @c))", tags),
          true);
    });
  });
}
