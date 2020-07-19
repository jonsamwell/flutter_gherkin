import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

import 'flutter_run_process_handler.dart';

class FlutterWorld extends World {
  FlutterDriver _driver;
  FlutterRunProcessHandler _flutterRunProcessHandler;

  FlutterDriver get driver => _driver;

  void setFlutterDriver(FlutterDriver flutterDriver) {
    _driver = flutterDriver;
  }

  void setFlutterProcessHandler(
      FlutterRunProcessHandler flutterRunProcessHandler) {
    _flutterRunProcessHandler = flutterRunProcessHandler;
  }

  Future<bool> restartApp({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    await _closeDriver(timeout: timeout);
    final result = await _flutterRunProcessHandler?.restart(
      timeout: timeout,
    );

    _driver = await FlutterDriver.connect(
      dartVmServiceUrl: _flutterRunProcessHandler.currentObservatoryUri,
    );

    return result;
  }

  @override
  void dispose() async {
    super.dispose();
    _flutterRunProcessHandler = null;
    await _closeDriver(timeout: const Duration(seconds: 5));
  }

  Future<void> _closeDriver({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    try {
      if (_driver != null) {
        await _driver
            .waitUntilNoTransientCallbacks(timeout: timeout)
            .catchError((e, st) {
          // Avoid an unhandled error.
          print(
              'Error waiting for no transient callbacks from Flutter driver:\n\n`$e`\n\n$st');
        });

        await _driver.close().catchError((e, st) {
          // Avoid an unhandled error.
          print('Error closing Flutter driver:\n\n`$e`\n\n$st');
        });
      }
    } catch (e, st) {
      print('Error closing Flutter driver:\n\n`$e`\n\n$st');
    } finally {
      _driver = null;
    }
  }
}
