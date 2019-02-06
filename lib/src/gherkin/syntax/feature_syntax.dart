import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/feature.dart';
import './syntax_matcher.dart';
import './regex_matched_syntax.dart';

class FeatureSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern =
      RegExp(r"^Feature:\s*(.+)\s*", multiLine: false, caseSensitive: false);

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) => false;

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final name = pattern.firstMatch(line).group(1);
    final runnable = FeatureRunnable(name, debug);
    return runnable;
  }
}
