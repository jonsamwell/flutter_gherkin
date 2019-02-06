import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/step_defined_parameter.dart';

class _SortedParameterPosition {
  final int startPosition;
  final CustomParameter<dynamic> parameter;

  _SortedParameterPosition(this.startPosition, this.parameter);
}

class GherkinExpression {
  final RegExp originalExpression;
  final List<_SortedParameterPosition> _sortedParameterPositions =
      <_SortedParameterPosition>[];
  RegExp _expression;

  GherkinExpression(this.originalExpression,
      Iterable<CustomParameter<dynamic>> customParameters) {
    String pattern = originalExpression.pattern;
    customParameters.forEach((p) {
      if (originalExpression.pattern.contains(p.identifier)) {
        // we need the index in the original pattern to be able to
        // transform the parameter into the correct type later on
        // so get that then modify the new matching pattern.
        originalExpression.pattern.replaceAllMapped(
            RegExp(_escapeIdentifier(p.identifier),
                caseSensitive: true, multiLine: true), (m) {
          _sortedParameterPositions.add(_SortedParameterPosition(m.start, p));
        });
        pattern = pattern.replaceAllMapped(
            RegExp(_escapeIdentifier(p.identifier),
                caseSensitive: true, multiLine: true),
            (m) => p.pattern.pattern);
      }
    });

    // check for any capture patterns that are not custom parameters
    // but defined directly in the step definition for example:
    //  Given I (open|close) the drawer(s)
    // note that we should ignore the predefined (s) plural parameter
    bool inCustomBracketSection = false;
    int indexOfOpeningBracket;
    for (var i = 0; i < originalExpression.pattern.length; i += 1) {
      final char = originalExpression.pattern[i];
      if (char == "(") {
        // look ahead and make sure we don't see "s)" which would
        // indicate the plural parameter
        if (originalExpression.pattern.length > i + 2) {
          final justAhead = originalExpression.pattern[i + 1] +
              originalExpression.pattern[i + 2];
          if (justAhead != "s)") {
            inCustomBracketSection = true;
            indexOfOpeningBracket = i;
          }
        }
      } else if (char == ")" && inCustomBracketSection) {
        _sortedParameterPositions.add(_SortedParameterPosition(
            indexOfOpeningBracket, UserDefinedStepParameterParameter()));
        inCustomBracketSection = false;
        indexOfOpeningBracket = 0;
      }
    }

    _sortedParameterPositions.sort((a, b) => a.startPosition - b.startPosition);
    _expression = RegExp(pattern,
        caseSensitive: originalExpression.isCaseSensitive,
        multiLine: originalExpression.isMultiLine);
  }

  String _escapeIdentifier(String identifier) =>
      identifier.replaceAll("(", "\\(").replaceAll(")", "\\)");

  bool isMatch(String input) {
    return _expression.hasMatch(input);
  }

  Iterable<dynamic> getParameters(String input) {
    final List<String> stringValues = <String>[];
    final List<dynamic> values = <dynamic>[];
    _expression.allMatches(input).forEach((m) {
      // the first group is always the input string
      final indicies =
          List.generate(m.groupCount, (i) => i + 1, growable: false).toList();
      stringValues.addAll(m.groups(indicies));
    });

    for (int i = 0; i < stringValues.length; i += 1) {
      final val = stringValues.elementAt(i);
      final cp = _sortedParameterPositions.elementAt(i);
      if (cp.parameter.includeInParameterList) {
        values.add(cp.parameter.transformer(val));
      }
    }

    return values;
  }
}
