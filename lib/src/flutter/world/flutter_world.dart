import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../adapters/app_driver_adapter.dart';

class FlutterWorld extends World {
  AppDriverAdapter _adapter;

  AppDriverAdapter get appDriver => _adapter;

  void setAppAdapter(AppDriverAdapter appAdapter) {
    _adapter = appAdapter;
  }

  Future<bool> restartApp({
    Duration timeout = const Duration(seconds: 60),
  }) {
    throw UnimplementedError('Unable to restart the app during the test');
  }
}
