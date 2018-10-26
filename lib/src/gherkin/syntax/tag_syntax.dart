import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/tags.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/regex_matched_syntax.dart';

class TagSyntax extends RegExMatchedGherkinSyntax {
  final RegExp pattern = RegExp("^@", multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final runnable = new TagsRunnable(debug);
    runnable.tags = line
        .trim()
        .split(RegExp("@"))
        .map((t) => t.trim())
        .where((t) => t != null && t.isNotEmpty);
    return runnable;
  }
}
