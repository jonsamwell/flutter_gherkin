import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';

import '../runners/flutter_run_process_handler.dart';

/// Driver version of the FlutterWorld with a typed driver
class FlutterDriverWorld extends FlutterTypedAdapterWorld<FlutterDriver,
    SerializableFinder, dynamic> {
  FlutterRunProcessHandler? _flutterRunProcessHandler;

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
    Duration? timeout = const Duration(seconds: 60),
  }) async {
    await _closeDriver(timeout: timeout);
    final result = await _flutterRunProcessHandler?.restart(
      timeout: timeout,
    );

    final driver = await FlutterDriver.connect(
      dartVmServiceUrl: _flutterRunProcessHandler!.currentObservatoryUri,
    );

    setFlutterDriver(driver);

    return result!;
  }

  @override
  void dispose() async {
    super.dispose();
    appDriver.dispose();
    _flutterRunProcessHandler = null;
    await _closeDriver(timeout: const Duration(seconds: 5));
  }

  Future<void> _closeDriver({
    Duration? timeout = const Duration(seconds: 60),
  }) async {
    await rawAppDriver.close().catchError(
      (e, st) {
        // Avoid an unhandled error
        return null;
      },
    );
  }
}
