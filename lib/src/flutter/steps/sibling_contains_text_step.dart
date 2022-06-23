import 'package:flutter_gherkin/flutter_gherkin.dart';
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
StepDefinitionGeneric siblingContainsTextStep() {
  return given3<String, String, String, FlutterWorld>(
    'I expect a {string} that contains the text {string} to also contain the text {string}',
    (ancestorType, leadingText, valueText, context) async {
      final ancestor = await context.world.appDriver.findByAncestor(
        context.world.appDriver.findBy(leadingText, FindType.text),
        context.world.appDriver.findBy(ancestorType, FindType.type),
        firstMatchOnly: true,
      );

      final valueWidget = await context.world.appDriver.findByDescendant(
        ancestor,
        context.world.appDriver.findBy(valueText, FindType.text),
        firstMatchOnly: true,
      );

      final isPresent = await context.world.appDriver.isPresent(
        valueWidget,
        timeout: context.configuration.timeout ?? const Duration(seconds: 20),
      );

      context.expect(isPresent, true);
    },
  );
}
