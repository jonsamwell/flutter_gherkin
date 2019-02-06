import 'package:flutter_gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/regex_matched_syntax.dart';

class CommentSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern = RegExp("^#", multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) =>
      CommentLineRunnable(line.trim(), debug);
}
