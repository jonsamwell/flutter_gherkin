import 'dart:async';

enum FindType {
  key,
  text,
  tooltip,
  type,
}

enum ExpectedWidgetResultType {
  first,
  last,
  list,
}

abstract class AppDriverAdapter<TRawAdapter, TFinderType, TWidgetBaseType> {
  TRawAdapter _driver;

  AppDriverAdapter(this._driver);

  TRawAdapter get rawDriver => _driver;

  void setRawDriver(TRawAdapter driver) {
    _driver = driver;
  }

  /// Returns the correct finder type instance
  /// `data` can be `String`, `Key` or a `Type`
  /// `findType` denotes the type of finder returned
  TFinderType findBy(
    dynamic data,
    FindType findType,
  );

  TFinderType findByAncestor(
    TFinderType of,
    TFinderType matching, {
    bool matchRoot = false,
    bool firstMatchOnly = false,
  });

  TFinderType findByDescendant(
    TFinderType of,
    TFinderType matching, {
    bool matchRoot = false,
    bool firstMatchOnly = false,
  });

  Future<int> waitForAppToSettle({
    Duration duration = const Duration(milliseconds: 100),
    Duration timeout = const Duration(seconds: 30),
  });

  Future<T> widget<T extends TWidgetBaseType>(
    TFinderType finder, [
    ExpectedWidgetResultType expectResultType = ExpectedWidgetResultType.first,
  ]);

  Future<List<int>> screenshot();

  Future<bool> isPresent(
    TFinderType finder, {
    Duration timeout = const Duration(seconds: 1),
  });

  Future<bool> isAbsent(
    TFinderType finder, {
    Duration timeout = const Duration(seconds: 1),
  });

  Future<void> enterText(
    TFinderType finder,
    String text, {
    Duration timeout = const Duration(seconds: 30),
  });

  Future<String> getText(
    TFinderType finder, {
    Duration timeout = const Duration(seconds: 30),
  });

  Future<void> tap(
    TFinderType finder, {
    Duration timeout = const Duration(seconds: 30),
  });

  Future<void> longPress(
    TFinderType finder, {
    Duration pressDuration = const Duration(milliseconds: 500),
    Duration timeout = const Duration(seconds: 30),
  });

  Future<void> pageBack();

  Future<void> scroll(
    TFinderType finder, {
    double dx = 0,
    double dy = 0,
    Duration duration = const Duration(seconds: 200),
    Duration timeout = const Duration(seconds: 30),
  });

  Future<void> scrollUntilVisible(
    TFinderType scrollable,
    TFinderType item, {
    double dx = 0,
    double dy = 0,
    Duration timeout = const Duration(seconds: 30),
  });

  Future<void> scrollIntoView(
    TFinderType finder, {
    Duration timeout = const Duration(seconds: 30),
  });

  Future<void> waitUntil(
    Future<bool> Function() condition, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 500),
  }) async {
    return Future.microtask(
      () async {
        final completer = Completer<void>();
        var maxAttempts =
            (timeout.inMilliseconds / pollInterval.inMilliseconds).round();
        var attempts = 0;

        while (attempts < maxAttempts) {
          final result = await condition();
          if (result) {
            completer.complete();
            break;
          } else {
            await Future.delayed(pollInterval);
          }
        }
      },
    ).timeout(
      timeout,
    );
  }

  void dispose() {}
}
