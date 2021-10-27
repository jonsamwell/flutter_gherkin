import 'dart:async';
import 'dart:ui' as ui show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_driver_adapter.dart';

class WidgetTesterAppDriverAdapter
    extends AppDriverAdapter<WidgetTester, Finder, Widget> {
  WidgetTesterAppDriverAdapter(WidgetTester rawAdapter) : super(rawAdapter);

  @override
  Future<int> waitForAppToSettle({
    Duration? duration = const Duration(milliseconds: 100),
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    try {
      final pumps = await nativeDriver.pumpAndSettle(
        duration ?? const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        timeout ?? const Duration(seconds: 30),
      );

      return pumps;
    } catch (_) {
      return 1;
    }
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

  @override
  Future<List<int>> screenshot() {
    var renderObject = nativeDriver.binding.renderViewElement?.renderObject;

    while (renderObject != null && !renderObject.isRepaintBoundary) {
      renderObject = renderObject.parent as RenderObject;
    }

    assert(renderObject != null && !renderObject.debugNeedsPaint);
    final layer = renderObject!.debugLayer as OffsetLayer;

    return layer
        .toImage(renderObject.semanticBounds)
        .then((value) => value.toByteData(format: ui.ImageByteFormat.png))
        .then((value) => value?.buffer.asUint8List() ?? List<int>.empty());
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
    await waitForAppToSettle(timeout: timeout);

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
    await waitForAppToSettle(
      timeout: timeout,
    );
  }

  @override
  Future<void> tap(
    Finder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.tap(finder);
    await waitForAppToSettle(
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
    await waitForAppToSettle(timeout: timeout);
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
      find.byType(Scrollable).first,
      matchRoot: true,
    );
    final state = nativeDriver.state(scrollableFinder) as ScrollableState;
    final position = state.position;
    position.jumpTo(dy ?? dx ?? 0);

    await nativeDriver.pump();
  }

  @override
  Finder findBy(
    dynamic data,
    FindType type,
  ) {
    switch (type) {
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
  }

  @override
  Future<void> scrollIntoView(
    Finder finder, {
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await nativeDriver.ensureVisible(finder);
    await waitForAppToSettle();
  }

  @override
  Future<void> pageBack() async {
    await nativeDriver.pageBack();
    await waitForAppToSettle();
  }
}
