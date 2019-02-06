import 'package:flutter_gherkin/src/gherkin/runnables/background.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/empty_line_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/regex_matched_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/scenario_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/syntax_matcher.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/tag_syntax.dart';

class BackgroundSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern = RegExp(r"^\s*Background:\s*(.+)\s*$",
      multiLine: false, caseSensitive: false);

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      syntax is ScenarioSyntax ||
      syntax is EmptyLineSyntax ||
      syntax is TagSyntax;

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final name = pattern.firstMatch(line).group(1);
    final runnable = BackgroundRunnable(name, debug);
    return runnable;
  }
}
