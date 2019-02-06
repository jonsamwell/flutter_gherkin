import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/table.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/regex_matched_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/syntax_matcher.dart';

class TableLineSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern =
      RegExp(r"^\s*\|.*\|\s*$", multiLine: false, caseSensitive: false);

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) {
    if (syntax is TableLineSyntax || syntax is CommentSyntax) {
      return false;
    }
    return true;
  }

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = TableRunnable(debug);
    runnable.rows.add(line.trim());
    return runnable;
  }
}
