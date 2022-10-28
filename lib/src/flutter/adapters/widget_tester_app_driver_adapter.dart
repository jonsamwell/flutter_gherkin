import 'dart:io' show Platform;
import 'dart:ui' as ui show ImageByteFormat;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'app_driver_adapter.dart';

class WidgetTesterAppDriverAdapter
    extends AppDriverAdapter<WidgetTester, Finder, Widget> {
  IntegrationTestWidgetsFlutterBinding binding;
  bool waitImplicitlyAfterAction;

  WidgetTesterAppDriverAdapter({
    required WidgetTester rawAdapter,
    required this.binding,
    required this.waitImplicitlyAfterAction,
  }) : super(rawAdapter);

  @override
  Future<int> waitForAppToSettle({
    Duration? duration = const Duration(milliseconds: 100),
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    final result = await _implicitWait(
      duration: duration,
      timeout: timeout,
      force: true,
    );

    return result;
  }

  Future<int> _implicitWait({
    Duration? duration = const Duration(milliseconds: 100),
    Duration? timeout = const Duration(seconds: 30),
    bool? force,
  }) async {
    if (waitImplicitlyAfterAction || force == true) {
      try {
        final result = await nativeDriver.pumpAndSettle(
          duration ?? const Duration(milliseconds: 100),
          EnginePhase.sendSemanticsUpdate,
          timeout ?? const Duration(seconds: 30),
        );

        return result;
      } catch (_) {
        return 0;
      }
    }

    return 0;
  }

  @override
  Future<T> widget<T extends Widget>(
    Finder finder, [
    ExpectedWidgetResultType expectResultType = ExpectedWidgetResultType.first,
  ]) {
    try {
      final element = nativeDriver.widget<T>(finder);

      return Future.value(element);
    } on StateError {
      throw TestFailure(
        'Unable to find element with finder ${finder.toString()}',
      );
    }
  }

  Future<List<int>> takeScreenshotUsingRenderElement() async {
    RenderObject? renderObject = binding.renderViewElement?.renderObject;
    if (renderObject != null) {
      while (!renderObject!.isRepaintBoundary) {
        renderObject = renderObject.parent as RenderObject?;
        assert(renderObject != null);
      }

      if (renderObject.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final layer = renderObject.debugLayer as OffsetLayer;

      return await layer
          .toImage(renderObject.semanticBounds)
          .then((value) => value.toByteData(format: ui.ImageByteFormat.png))
          .then((value) => value!.buffer.asUint8List());
    }

    throw Exception('Unable to take screenshot on Android device');
  }

  @override
  Future<List<int>> screenshot({String? screenshotName}) async {
    final name =
        screenshotName ?? 'screenshot_${DateTime.now().millisecondsSinceEpoch}';
    if (kIsWeb || Platform.isAndroid) {
      // try {
      //   // TODO: See https://github.com/flutter/flutter/issues/92381
      //   // we need to call `revertFlutterImage` once it has been implemented
      //   await binding.convertFlutterSurfaceToImage();
      //   await binding.pump();
      //   // ignore: no_leading_underscores_for_local_identifiers
      // } catch (_, __) {}

      return await takeScreenshotUsingRenderElement();
    } else {
      return await binding.takeScreenshot(name);
    }
  }

  @override
  Future<bool> isPresent(
    Finder finder, {
    Duration? timeout = const Duration(seconds: 1),
  }) async {
    return finder.evaluate().isNotEmpty;
  }

  @override
  Future<bool> isAbsent(
    Finder finder, {
    Duration? timeout = const Duration(seconds: 1),
  }) async {
    return await isPresent(finder).then((value) => !value);
  }

  @override
  Future<String?> getText(
    Finder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await _implicitWait(timeout: timeout);

    final instance = await widget(finder);
    if (instance is Text) {
      return instance.data;
    } else if (instance is TextSpan) {
      return (instance as TextSpan).text;
    } else if (instance is TextFormField) {
      return instance.controller?.text;
    }

    throw Exception(
        'Unable to get text from unknown type `${instance.runtimeType}`');
  }

  @override
  Future<void> enterText(
    Finder finder,
    String text, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.enterText(
      finder,
      text,
    );
    await _implicitWait(
      timeout: timeout,
    );
  }

  @override
  Future<void> tap(
    Finder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.tap(finder);
    await _implicitWait(
      timeout: timeout,
    );
  }

  @override
  Future<void> longPress(
    Finder finder, {
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

    await _implicitWait(timeout: timeout);
  }

  @override
  Finder findBy(
    dynamic data,
    FindType findType,
  ) {
    switch (findType) {
      case FindType.key:
        return find.byKey(data is Key ? data : Key(data));
      case FindType.text:
        return find.text(data);
      case FindType.tooltip:
        return find.byTooltip(data);
      case FindType.type:
        return find.byType(data);
    }
  }

  @override
  Finder findByAncestor(
    Finder of,
    Finder matching, {
    bool matchRoot = false,
    bool firstMatchOnly = false,
  }) {
    return find.ancestor(
      of: of,
      matching: matching,
      matchRoot: matchRoot,
    );
  }

  @override
  Finder findByDescendant(
    Finder of,
    Finder matching, {
    bool matchRoot = false,
    bool firstMatchOnly = false,
  }) {
    return find.descendant(
      of: of,
      matching: matching,
      matchRoot: matchRoot,
    );
  }

  @override
  Future<void> scroll(
    Finder finder, {
    double? dx,
    double? dy,
    Duration? duration = const Duration(milliseconds: 200),
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    final scrollableFinder = findByDescendant(
      finder,
      find.byType(Scrollable),
      matchRoot: true,
    );
    final state = nativeDriver.firstState(scrollableFinder) as ScrollableState;
    final position = state.position;
    position.jumpTo(dy ?? dx ?? 0);

    // must force a pump and settle to ensure the scroll is performed
    await _implicitWait(
      duration: duration,
      timeout: timeout,
      force: true,
    );
  }

  @override
  Future<void> scrollUntilVisible(
    Finder item, {
    Finder? scrollable,
    double? dx,
    double? dy,
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.scrollUntilVisible(
      item,
      dy ?? dx ?? 0,
      scrollable: scrollable,
    );

    // must force a pump and settle to ensure the scroll is performed
    await _implicitWait(
      timeout: timeout,
      force: true,
    );
  }

  @override
  Future<void> scrollIntoView(
    Finder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.ensureVisible(finder);

    // must force a pump and settle to ensure the scroll is performed
    await _implicitWait(
      timeout: timeout,
      force: true,
    );
  }

  @override
  Future<void> pageBack() async {
    await nativeDriver.pageBack();
    await _implicitWait();
  }
}
