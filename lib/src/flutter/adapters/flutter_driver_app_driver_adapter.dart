import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import 'app_driver_adapter.dart';

class FlutterDriverAppDriverAdapter
    extends AppDriverAdapter<FlutterDriver, SerializableFinder, dynamic> {
  FlutterDriverAppDriverAdapter(FlutterDriver rawAdapter) : super(rawAdapter);

  @override
  Future<int> waitForAppToSettle({
    Duration? duration = const Duration(milliseconds: 100),
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    try {
      await nativeDriver.waitUntilNoTransientCallbacks(timeout: timeout);
    } catch (_) {
      return 1;
    }

    return 0;
  }

  @override
  Future<T> widget<T extends dynamic>(
    SerializableFinder finder, [
    ExpectedWidgetResultType expectResultType = ExpectedWidgetResultType.first,
  ]) {
    throw UnimplementedError(
      'Flutter driver does not support directly interacting with the widget tree',
    );
  }

  @override
  void dispose() {
    nativeDriver.close().catchError(
      (e, st) {
        // Avoid an unhandled error
        return null;
      },
    );
  }

  @override
  Future<List<int>> screenshot({
    String? screenshotName,
  }) {
    return nativeDriver.screenshot();
  }

  @override
  Future<bool> isPresent(
    SerializableFinder finder, {
    Duration? timeout = const Duration(seconds: 1),
  }) async {
    try {
      await nativeDriver.waitFor(
        finder,
        timeout: timeout,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isAbsent(
    SerializableFinder finder, {
    Duration? timeout = const Duration(seconds: 1),
  }) async {
    try {
      await nativeDriver.waitForAbsent(
        finder,
        timeout: timeout,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> getText(
    SerializableFinder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await waitForAppToSettle(timeout: timeout);

    return await nativeDriver.getText(
      finder,
      timeout: timeout,
    );
  }

  @override
  Future<void> enterText(
    SerializableFinder finder,
    String text, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await tap(
      finder,
      timeout: timeout,
    );
    await nativeDriver.enterText(
      text,
      timeout: timeout,
    );
  }

  @override
  Future<void> tap(
    SerializableFinder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.tap(finder, timeout: timeout);
    await waitForAppToSettle(timeout: timeout);
  }

  @override
  Future<void> longPress(
    SerializableFinder finder, {
    Duration? pressDuration = const Duration(milliseconds: 500),
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await scroll(
      finder,
      dx: 0,
      dy: 0,
      duration: pressDuration,
      timeout: timeout,
    );
    await waitForAppToSettle(timeout: timeout);
  }

  @override
  Future<void> scroll(
    SerializableFinder finder, {
    double? dx,
    double? dy,
    Duration? duration = const Duration(milliseconds: 200),
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.scroll(
      finder,
      dx ?? 0,
      dy ?? 0,
      duration ?? const Duration(milliseconds: 200),
      timeout: timeout,
    );
    await waitForAppToSettle(timeout: timeout);
  }

  @override
  SerializableFinder findBy(
    dynamic data,
    FindType findType,
  ) {
    switch (findType) {
      case FindType.key:
        return find.byValueKey(data.toString());
      case FindType.text:
        return find.text(data);
      case FindType.tooltip:
        return find.byTooltip(data);
      case FindType.type:
        return find.byType(data.toString());
    }
  }

  @override
  SerializableFinder findByAncestor(
    SerializableFinder of,
    SerializableFinder matching, {
    bool matchRoot = false,
    bool firstMatchOnly = false,
  }) {
    return find.ancestor(
      of: of,
      matching: matching,
      matchRoot: matchRoot,
      firstMatchOnly: firstMatchOnly,
    );
  }

  @override
  SerializableFinder findByDescendant(
    SerializableFinder of,
    SerializableFinder matching, {
    bool matchRoot = false,
    bool firstMatchOnly = false,
  }) {
    return find.descendant(
      of: of,
      matching: matching,
      matchRoot: matchRoot,
      firstMatchOnly: firstMatchOnly,
    );
  }

  @override
  Future<void> scrollUntilVisible(
    SerializableFinder item, {
    SerializableFinder? scrollable,
    double? dx,
    double? dy,
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.scrollUntilVisible(
      scrollable!,
      item,
      timeout: timeout,
      dxScroll: dx ?? 0,
      dyScroll: dy ?? 0,
    );
  }

  @override
  Future<void> scrollIntoView(
    SerializableFinder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.scrollIntoView(
      finder,
      timeout: timeout,
    );
  }

  @override
  Future<void> pageBack() async {
    await tap(find.pageBack());
    await waitForAppToSettle();
  }
}
