import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import 'adapters/app_driver_adapter.dart';
import 'flutter_run_process_handler.dart';

abstract class FlutterWorld extends World {
  AppDriverAdapter _adapter;

  AppDriverAdapter get appDriver => _adapter;

  void setAppAdapter(AppDriverAdapter appAdapter) {
    _adapter = appAdapter;
  }

  Future<bool> restartApp({
    Duration timeout = const Duration(seconds: 60),
  });
}

class FlutterDriverWorld extends FlutterWorld {
  FlutterRunProcessHandler _flutterRunProcessHandler;

  FlutterDriver get driver => appDriver.rawDriver as FlutterDriver;

  void setFlutterDriver(FlutterDriver flutterDriver) {
    setAppAdapter(FlutterDriverAppDriverAdapter(flutterDriver));
  }

  void setFlutterProcessHandler(
    FlutterRunProcessHandler flutterRunProcessHandler,
  ) {
    _flutterRunProcessHandler = flutterRunProcessHandler;
  }

  @override
  Future<bool> restartApp({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    await _closeDriver(timeout: timeout);
    final result = await _flutterRunProcessHandler?.restart(
      timeout: timeout,
    );

    final driver = await FlutterDriver.connect(
      dartVmServiceUrl: _flutterRunProcessHandler.currentObservatoryUri,
    );

    setFlutterDriver(driver);

    return result;
  }

  @override
  void dispose() async {
    super.dispose();
    appDriver.dispose();
    _flutterRunProcessHandler = null;
    await _closeDriver(timeout: const Duration(seconds: 5));
  }

  Future<void> _closeDriver({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (driver != null) {
      await driver.close().catchError(
        (e, st) {
          // Avoid an unhandled error
          return null;
        },
      );
    }
  }
}
