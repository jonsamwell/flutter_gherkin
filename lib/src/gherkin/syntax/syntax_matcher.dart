import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';

enum EndBlockHandling { ignore, continueProcessing }

abstract class SyntaxMatcher {
  bool isMatch(String line);
  bool get isBlockSyntax => false;
  bool hasBlockEnded(SyntaxMatcher syntax) => true;
  EndBlockHandling endBlockHandling(SyntaxMatcher syntax) =>
      EndBlockHandling.continueProcessing;
  Runnable toRunnable(String line, RunnableDebugInformation debug) => null;
}
