import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../adapters/app_driver_adapter.dart';

/// The world object that can be used to store state during a single test.
/// It also allows interaction with the app under test through the `appDriver`
/// which exposes an instance of `AppDriverAdapter`
class FlutterWorld<TDriver> extends World {
  AppDriverAdapter _adapter;

  /// The adapter that is used to agnostically drive the app under test
  AppDriverAdapter get appDriver => _adapter;

  /// The underlying driver that is able to instrument the app under test
  /// It is suggested you use `appDriver` for all interactions with the app under tests
  /// however if you need a specific api not available on `appDriver` this property
  /// exposes the actual class that can interact with the app under test
  TDriver get rawAppDriver => _adapter.rawDriver as TDriver;

  /// Sets the app driver that is used to control the app under test
  void setAppAdapter(AppDriverAdapter appAdapter) {
    _adapter = appAdapter;
  }

  /// Restart the app under test
  Future<bool> restartApp({
    Duration timeout = const Duration(seconds: 60),
  }) {
    throw UnimplementedError('Unable to restart the app during the test');
  }
}
