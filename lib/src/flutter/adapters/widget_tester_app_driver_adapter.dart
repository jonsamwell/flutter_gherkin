import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_driver_adapter.dart';

class WidgetTesterAppDriverAdapter
    extends AppDriverAdapter<WidgetTester, Finder, Widget> {
  WidgetTesterAppDriverAdapter(WidgetTester rawAdapter) : super(rawAdapter);

  @override
  Future<int> waitForAppToSettle({
    Duration duration = const Duration(milliseconds: 100),
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      await rawDriver.pumpAndSettle(
        duration,
        EnginePhase.sendSemanticsUpdate,
        timeout,
      );
    } catch (_) {
      return null;
    }

    return null;
  }

  @override
  Future<T> widget<T extends Widget>(Finder finder) {
    return Future.value(rawDriver.widget<T>(finder));
  }

  @override
  Future<List<int>> screenshot() {
    var renderObject = rawDriver.binding.renderViewElement.renderObject;
    while (!renderObject.isRepaintBoundary) {
      renderObject = renderObject.parent as RenderObject;
      assert(renderObject != null);
    }
    assert(!renderObject.debugNeedsPaint);
    final layer = renderObject.debugLayer as OffsetLayer;

    return layer
        .toImage(renderObject.paintBounds)
        .then((value) => value.toByteData())
        .then((value) => value.buffer.asInt64List());
  }

  @override
  Future<bool> isPresent(
    Finder finder, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    try {
      final element = await widget(finder);
      return element != null;
    } on StateError {
      return false;
    }
  }

  @override
  Future<bool> isAbsent(
    Finder finder, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    return await isPresent(finder).then((value) => !value);
  }

  @override
  Future<String> getText(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await waitForAppToSettle(timeout: timeout);

    final instance = await widget(finder);
    if (instance is Text) {
      return instance.data;
    } else if (instance is TextSpan) {
      return (instance as TextSpan).text;
    }

    throw Exception(
        'Unable to get text from unknown type `${instance.runtimeType}`');
  }

  @override
  Future<void> enterText(
    Finder finder,
    String text, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await tap(
      finder,
      timeout: timeout,
    );
    await rawDriver.enterText(
      finder,
      text,
    );
  }

  @override
  Future<void> tap(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await rawDriver.tap(finder);
    await waitForAppToSettle(timeout: timeout);
  }

  @override
  Future<void> longPress(
    Finder finder, {
    Duration pressDuration = const Duration(milliseconds: 500),
    Duration timeout = const Duration(seconds: 30),
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
    double dx = 0,
    double dy = 0,
    Duration duration = const Duration(seconds: 200),
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await rawDriver.scrollUntilVisible(
      finder,
      dx,
      duration: duration,
    );
    await waitForAppToSettle(timeout: timeout);
  }

  @override
  Finder findBy(String data, FindType type) {
    switch (type) {
      case FindType.key:
        return find.byKey(ValueKey(data));
      case FindType.text:
        return find.text(data);
      case FindType.tooltip:
        return find.byTooltip(data);
      case FindType.type:
      // return find.byType(data);
    }

    throw Exception('unknown finder');
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
    Finder scrollable,
    Finder item, {
    double dx = 0,
    double dy = 0,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await rawDriver.scrollUntilVisible(
      item,
      dx,
      scrollable: scrollable,
    );
  }

  @override
  Future<void> scrollIntoView(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await rawDriver.ensureVisible(finder);
  }

  @override
  Future<void> pageBack() async {
    await rawDriver.pageBack();
  }
}
