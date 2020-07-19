import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

/// Discovers a widget by its text within the same parent.
/// For example, discovering X while only being aware of Y:
///   Row(children: [
///     Text('Y'),
///     Text('X')
///   ])
///
/// Examples:
///
///   `Then I expect a "Row" that contains the text "X" to also contain the text "Y"`
StepDefinitionGeneric SiblingContainsTextStep() {
  return given3<String, String, String, FlutterWorld>(
    'I expect a {string} that contains the text {string} to also contain the text {string}',
    (ancestorType, leadingText, valueText, context) async {
      final ancestor = await find.ancestor(
        of: find.text(leadingText),
        matching: find.byType(ancestorType),
        firstMatchOnly: true,
      );

      final valueWidget = await find.descendant(
        of: ancestor,
        matching: find.text(valueText),
        firstMatchOnly: true,
      );

      final isPresent = await FlutterDriverUtils.isPresent(
        context.world.driver,
        valueWidget,
        timeout: context.configuration?.timeout ?? const Duration(seconds: 20),
      );

      context.expect(isPresent, true);
    },
  );
}
