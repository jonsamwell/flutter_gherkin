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

abstract class AppDriverAdapter<TNativeAdapter, TFinderType, TWidgetBaseType> {
  TNativeAdapter _driver;

  AppDriverAdapter(this._driver);

  TNativeAdapter get nativeDriver => _driver;

  void setNativeDriver(TNativeAdapter driver) {
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

  /// Finds widgets that are descendants of the [of] parameter and that match the [matching] parameter.
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

  Future<List<int>> screenshot({
    String? screenshotName,
  });

  Future<bool> isPresent(
    TFinderType finder, {
    Duration? timeout = const Duration(seconds: 1),
  });

  Future<bool> isAbsent(
    TFinderType finder, {
    Duration? timeout = const Duration(seconds: 1),
  });

  Future<void> enterText(
    TFinderType finder,
    String text, {
    Duration? timeout = const Duration(seconds: 30),
  });

  Future<String?> getText(
    TFinderType finder, {
    Duration? timeout = const Duration(seconds: 30),
  });

  Future<void> tap(
    TFinderType finder, {
    Duration? timeout = const Duration(seconds: 30),
  });

  Future<void> longPress(
    TFinderType finder, {
    Duration pressDuration = const Duration(milliseconds: 500),
    Duration? timeout = const Duration(seconds: 30),
  });

  Future<void> pageBack();

  /// Scrolls a descendant scrollable widget by the give parameters
  Future<void> scroll(
    TFinderType finder, {
    double dx,
    double dy,
    Duration? duration = const Duration(milliseconds: 200),
    Duration? timeout = const Duration(seconds: 30),
  });

  /// Repeatedly scrolls a [Scrollable] by delta until finder is visible.
  /// Between each scroll, wait for duration time for settling.
  /// If scrollable is null, this will find a [Scrollable].
  Future<void> scrollUntilVisible(
    TFinderType item, {
    TFinderType scrollable,
    double dx,
    double dy,
    Duration? timeout = const Duration(seconds: 30),
  });

  Future<void> scrollIntoView(
    TFinderType finder, {
    Duration? timeout = const Duration(seconds: 30),
  });

  /// Will wait until the give condition returns `true` polling every `pollInterval`. If `condition` has not returned true
  /// within the given `timeout` this will cause the returned future to complete with a [TimeoutException].
  Future<void> waitUntil(
    Future<bool> Function() condition, {
    Duration? timeout = const Duration(seconds: 10),
    Duration? pollInterval = const Duration(milliseconds: 500),
  }) async {
    return Future.microtask(
      () async {
        final completer = Completer<void>();
        var maxAttempts =
            (timeout!.inMilliseconds / pollInterval!.inMilliseconds).round();
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
      timeout!,
    );
  }

  void dispose() {}
}
