import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/language.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/language_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final keyword = new LanguageSyntax();
      expect(keyword.isMatch("# language: en"), true);
      expect(keyword.isMatch("#language: fr"), true);
      expect(keyword.isMatch("#language:de"), true);
    });

    test('does not match', () {
      final keyword = new LanguageSyntax();
      expect(keyword.isMatch("#language no"), false);
      expect(keyword.isMatch("# language comment"), false);
    });
  });

  group("toRunnable", () {
    test('creates LanguageRunnable', () {
      final keyword = new LanguageSyntax();
      LanguageRunnable runnable = keyword.toRunnable(
          "# language: de", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is LanguageRunnable));
      expect(runnable.language, equals("de"));
    });
  });
}
