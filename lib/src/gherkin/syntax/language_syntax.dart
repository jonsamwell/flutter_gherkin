import '../runnables/debug_information.dart';
import '../runnables/language.dart';
import '../runnables/runnable.dart';
import './regex_matched_syntax.dart';

/// see https://docs.cucumber.io/gherkin/reference/#gherkin-dialects
class LanguageSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern = RegExp(r"^\s*#\s*language:\s*([a-z]{2,7})\s*$",
      multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = LanguageRunnable(debug);
    runnable.language = pattern.firstMatch(line).group(1);
    return runnable;
  }
}
