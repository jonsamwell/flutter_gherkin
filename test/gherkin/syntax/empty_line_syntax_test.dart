import 'package:flutter_gherkin/src/gherkin/syntax/empty_line_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final keyword = EmptyLineSyntax();
      expect(keyword.isMatch(""), true);
      expect(keyword.isMatch(" "), true);
      expect(keyword.isMatch("  "), true);
      expect(keyword.isMatch("    "), true);
    });

    test('does not match', () {
      final keyword = EmptyLineSyntax();
      expect(keyword.isMatch("a"), false);
      expect(keyword.isMatch(" b"), false);
      expect(keyword.isMatch("  c"), false);
      expect(keyword.isMatch("    ,"), false);
    });
  });
}
