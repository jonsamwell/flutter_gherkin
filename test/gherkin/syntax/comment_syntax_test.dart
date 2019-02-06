import 'package:flutter_gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final keyword = CommentSyntax();
      expect(keyword.isMatch("# I am a comment"), true);
      expect(keyword.isMatch("#I am also a comment"), true);
      expect(keyword.isMatch("## I am also a comment"), true);
      expect(keyword.isMatch("# Language something"), true);
    });

    test('does not match', () {
      final keyword = CommentSyntax();
      // expect(keyword.isMatch("# language: en"), false);
      expect(keyword.isMatch("I am not a comment"), false);
    });
  });
}
