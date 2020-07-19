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
class SiblingContainsTextStep
    extends When3WithWorld<String, String, String, FlutterWorld> {
  @override
  Future<void> executeStep(
      String ancestorType, String leadingText, String valueText) async {
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
      world.driver,
      valueWidget,
      timeout: timeout,
    );

    expect(isPresent, true);
  }

  @override
  RegExp get pattern => RegExp(
      r'I expect a {string} that contains the text {string} to also contain the text {string}');
}
