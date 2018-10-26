import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/regex_matched_syntax.dart';

class EmptyLineSyntax extends RegExMatchedGherkinSyntax {
  final RegExp pattern =
      RegExp(r"^\s*$", multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) =>
      EmptyLineRunnable(debug);
}
