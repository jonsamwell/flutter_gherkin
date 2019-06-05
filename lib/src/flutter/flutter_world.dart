import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class FlutterWorld extends World {
  FlutterDriver _driver;

  FlutterDriver get driver => _driver;

  void setFlutterDriver(FlutterDriver flutterDriver) {
    _driver = flutterDriver;
  }

  @override
  void dispose() async {
    await _driver?.close();
  }
}
