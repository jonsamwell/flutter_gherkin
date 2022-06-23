// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../parameters/swipe_direction_parameter.dart';

mixin _SwipeHelper
    on When3WithWorld<SwipeDirection, int, String, FlutterWorld> {
  Future<void> swipeOnFinder(
    dynamic finder,
    SwipeDirection direction,
    int swipeAmount,
  ) async {
    if (direction == SwipeDirection.left || direction == SwipeDirection.right) {
      final offset =
          direction == SwipeDirection.right ? swipeAmount : (swipeAmount * -1);

      await world.appDriver.scroll(
        finder,
        dx: offset.toDouble(),
        duration: const Duration(milliseconds: 500),
        timeout: timeout,
      );
    } else {
      final offset =
          direction == SwipeDirection.up ? swipeAmount : (swipeAmount * -1);

      await world.appDriver.scroll(
        finder,
        dy: offset.toDouble(),
        duration: const Duration(milliseconds: 500),
        timeout: timeout,
      );
    }
  }
}

/// Swipes in a cardinal direction on a widget discovered by its key.
///
/// Examples:
///
///   `Then I swipe up by 800 pixels on the "login_screen"`
///   `Then I swipe left by 200 pixels on the "dismissible_list_item"`
class SwipeOnKeyStep
    extends When3WithWorld<SwipeDirection, int, String, FlutterWorld>
    with _SwipeHelper {
  @override
  Future<void> executeStep(
    SwipeDirection direction,
    int swipeAmount,
    String key,
  ) async {
    final finder = world.appDriver.findBy(key, FindType.key);
    await swipeOnFinder(finder, direction, swipeAmount);
  }

  @override
  RegExp get pattern =>
      RegExp(r'I swipe {swipe_direction} by {int} pixels on the {string}');
}

/// Swipes in a cardinal direction on a widget discovered by its test.
///
/// Examples:
///
///   `Then I swipe left by 400 pixels on the widget that contains the text "Dismiss Me"`
class SwipeOnTextStep
    extends When3WithWorld<SwipeDirection, int, String, FlutterWorld>
    with _SwipeHelper {
  @override
  Future<void> executeStep(
    SwipeDirection direction,
    int swipeAmount,
    String text,
  ) async {
    final finder = world.appDriver.findBy(text, FindType.text);
    await swipeOnFinder(finder, direction, swipeAmount);
  }

  @override
  RegExp get pattern => RegExp(
      r'I swipe {swipe_direction} by {int} pixels on the (?:button|element|label|field|text|widget|dialog|popup) that contains the text {string}');
}
