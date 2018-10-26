import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/tags.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/tag_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = new TagSyntax();
      expect(syntax.isMatch("@tagone @tagtow @tag_three"), true);
      expect(syntax.isMatch("@tag"), true);
    });

    test('does not match', () {
      final syntax = new TagSyntax();
      expect(syntax.isMatch("not a tag"), false);
      expect(syntax.isMatch("#@tag @tag2"), false);
    });
  });

  group("toRunnable", () {
    test('creates TextLineRunnable', () {
      final syntax = new TagSyntax();
      TagsRunnable runnable = syntax.toRunnable(
          "@tag1 @tag2   @tag3@tag_4", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is TagsRunnable));
      expect(runnable.tags, equals(["tag1", "tag2", "tag3", "tag_4"]));
    });
  });
}
