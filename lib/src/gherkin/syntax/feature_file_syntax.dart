import 'package:flutter_gherkin/src/gherkin/syntax/syntax_matcher.dart';

class FeatureFileSyntax extends SyntaxMatcher {
  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) => false;

  @override
  bool isMatch(String line) {
    return false;
  }
}
