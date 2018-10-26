import './syntax_matcher.dart';

abstract class RegExMatchedGherkinSyntax extends SyntaxMatcher {
  RegExp get pattern;

  @override
  bool isMatch(String line) {
    final match = pattern.hasMatch(line);
    return match;
  }
}
