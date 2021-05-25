import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../adapters/app_driver_adapter.dart';

/// The world object that can be used to store state during a single test.
/// It also allows interaction with the app under test through the `appDriver`
/// which exposes an instance of `AppDriverAdapter`
class FlutterWorld extends World {
  AppDriverAdapter? _adapter;

  /// The adapter that is used to agnostically drive the app under test
  AppDriverAdapter get appDriver => _adapter!;

  /// Sets the app driver that is used to control the app under test
  void setAppAdapter(AppDriverAdapter appAdapter) {
    _adapter = appAdapter;
  }

  /// Restart the app under test
  Future<bool> restartApp({
    Duration? timeout = const Duration(seconds: 60),
  }) {
    throw UnimplementedError('Unable to restart the app during the test');
  }
}

/// The world object that can be used to store state during a single test.
/// It also allows interaction with the app under test through the `appDriver`
/// which exposes an instance of `AppDriverAdapter` and a typed instance of `TDriver`
/// of the actual class that is able to interact with the app under test
class FlutterTypedAdapterWorld<TDriver, TFinder, TWidget> extends FlutterWorld {
  /// The underlying driver that is able to instrument the app under test
  /// It is suggested you use `appDriver` for all interactions with the app under tests
  /// however if you need a specific api not available on `appDriver` this property
  /// exposes the actual class that can interact with the app under test
  TDriver get rawAppDriver => _adapter!.nativeDriver as TDriver;

  /// The adapter that is used to agnostically drive the app under test
  @override
  AppDriverAdapter<TDriver, TFinder, TWidget> get appDriver =>
      _adapter as AppDriverAdapter<TDriver, TFinder, TWidget>;
}
