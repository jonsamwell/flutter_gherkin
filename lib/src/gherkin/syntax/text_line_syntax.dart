import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/text_line.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/regex_matched_syntax.dart';

class TextLineSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern =
      RegExp(r"^\s*(?!#)\w+.*]*$", multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = TextLineRunnable(debug);
    runnable.text = line.trim();
    return runnable;
  }
}
