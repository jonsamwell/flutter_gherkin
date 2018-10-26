import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/step.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/multiline_string_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/regex_matched_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/syntax_matcher.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/table_line_syntax.dart';

class StepSyntax extends RegExMatchedGherkinSyntax {
  final RegExp pattern = RegExp(r"^(given|then|when|and|but)\s.*",
      multiLine: false, caseSensitive: false);

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      !(syntax is MultilineStringSyntax || syntax is TableLineSyntax);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = new StepRunnable(line, debug);
    return runnable;
  }
}
