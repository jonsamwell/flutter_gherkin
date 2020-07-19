import 'package:meta/meta.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

import '../parameters/swipe_direction_parameter.dart';

mixin _SwipeHelper
    on When3WithWorld<SwipeDirection, int, String, FlutterWorld> {
  @protected
  Future<void> swipeOnFinder(
    SerializableFinder finder,
    SwipeDirection direction,
    int swipeAmount,
  ) async {
    if (direction == SwipeDirection.left || direction == SwipeDirection.right) {
      final offset =
          direction == SwipeDirection.right ? swipeAmount : (swipeAmount * -1);

      await world.driver.scroll(
        finder,
        offset.toDouble(),
        0,
        Duration(milliseconds: 500),
        timeout: timeout,
      );
    } else {
      final offset =
          direction == SwipeDirection.up ? swipeAmount : (swipeAmount * -1);

      await world.driver.scroll(
        finder,
        0,
        offset.toDouble(),
        Duration(milliseconds: 500),
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
    final finder = find.byValueKey(key);
    await swipeOnFinder(finder, direction, swipeAmount);
  }

  @override
  RegExp get pattern =>
      RegExp(r'I swipe {swipe_direction} by {int} pixels on the {string}$');
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
    final finder = find.text(text);
    await swipeOnFinder(finder, direction, swipeAmount);
  }

  @override
  RegExp get pattern => RegExp(
      r'I swipe {swipe_direction} by {int} pixels on the (?:button|element|label|field|text|widget|dialog|popup) that contains the text {string}');
}
