import 'package:flutter_gherkin/src/gherkin/steps/world.dart';
import 'package:flutter_driver/flutter_driver.dart';

class FlutterWorld extends World {
  FlutterDriver _driver;

  FlutterDriver get driver => _driver;

  setFlutterDriver(FlutterDriver flutterDriver) {
    _driver = flutterDriver;
  }

  @override
  void dispose() {
    _driver.close();
  }
}
