import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

class FlutterDriverUtils {
  static Future<bool> isPresent(
    FlutterDriver driver,
    SerializableFinder finder, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    try {
      await driver.waitFor(finder, timeout: timeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isAbsent(
    FlutterDriver driver,
    SerializableFinder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      await driver.waitForAbsent(finder, timeout: timeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> waitForFlutter(
    FlutterDriver driver, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      await driver.waitUntilNoTransientCallbacks(timeout: timeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> enterText(
    FlutterDriver driver,
    SerializableFinder finder,
    String text, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await FlutterDriverUtils.tap(driver, finder, timeout: timeout);
    await driver.enterText(text, timeout: timeout);
  }

  static Future<String> getText(
    FlutterDriver driver,
    SerializableFinder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await FlutterDriverUtils.waitForFlutter(driver, timeout: timeout);
    final text = await driver.getText(finder, timeout: timeout);
    return text;
  }

  static Future<void> tap(
    FlutterDriver driver,
    SerializableFinder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await driver.tap(finder, timeout: timeout);
    await FlutterDriverUtils.waitForFlutter(driver, timeout: timeout);
  }

  /// Waits until the [condition] returns true
  /// Will raise a complete with a [TimeoutException] if the
  /// condition does not return true with the timeout period.
  static Future<void> waitUntil(
    FlutterDriver driver,
    Future<bool> condition(), {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 500),
  }) async {
    return Future.microtask(() async {
      final completer = Completer<void>();
      int maxAttempts =
          (timeout.inMilliseconds / pollInterval.inMilliseconds).round();
      int attempts = 0;

      while (attempts < maxAttempts) {
        final result = await condition();
        if (result) {
          completer.complete();
          break;
        } else {
          await Future.delayed(pollInterval);
        }
      }
    }).timeout(timeout);
  }
}
