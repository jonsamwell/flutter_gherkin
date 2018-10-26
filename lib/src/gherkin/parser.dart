import 'package:flutter_gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable_block.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/background_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/empty_line_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/feature_file_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/feature_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/language_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/multiline_string_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/scenario_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/step_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/syntax_matcher.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/table_line_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/tag_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/text_line_syntax.dart';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/reporter.dart';

class GherkinParser {
  final Iterable<SyntaxMatcher> syntaxMatchers = [
    LanguageSyntax(),
    CommentSyntax(),
    FeatureSyntax(),
    BackgroundSyntax(),
    TagSyntax(),
    ScenarioSyntax(),
    StepSyntax(),
    MultilineStringSyntax(),
    EmptyLineSyntax(),
    TableLineSyntax(),
    TextLineSyntax()
  ];

  Future<FeatureFile> parseFeatureFile(
      String contents, String path, Reporter reporter) async {
    final featureFile = FeatureFile(RunnableDebugInformation(path, 0, null));
    await reporter.message("Parsing feature file: '$path'", MessageLevel.debug);
    final lines =
        contents.trim().split(RegExp(r"(\r\n|\r|\n)", multiLine: true));
    try {
      _parseBlock(FeatureFileSyntax(), featureFile, lines, 0, 0);
    } catch (e) {
      await reporter.message(
          "Error while parsing feature file: '$path'\n$e", MessageLevel.error);
      rethrow;
    }
    return featureFile;
  }

  num _parseBlock(SyntaxMatcher parentSyntaxBlock, RunnableBlock parentBlock,
      Iterable<String> lines, int lineNumber, int depth) {
    for (int i = lineNumber; i < lines.length; i += 1) {
      final line = lines.elementAt(i).trim();
      // print("$depth - $line");
      final matcher = syntaxMatchers
          .firstWhere((matcher) => matcher.isMatch(line), orElse: () => null);
      if (matcher != null) {
        if (parentSyntaxBlock.hasBlockEnded(matcher)) {
          switch (parentSyntaxBlock.endBlockHandling(matcher)) {
            case EndBlockHandling.ignore:
              return i;
            case EndBlockHandling.continueProcessing:
              return i - 1;
          }
        }

        final runnable =
            matcher.toRunnable(line, parentBlock.debug.copyWith(i, line));
        if (runnable is RunnableBlock) {
          i = _parseBlock(matcher, runnable, lines, i + 1, depth + 1);
        }

        parentBlock.addChild(runnable);
      } else {
        throw new GherkinSyntaxException(
            "Unknown or un-implemented syntax: '$line', file: '${parentBlock.debug.filePath}");
      }
    }

    return lines.length;
  }
}
