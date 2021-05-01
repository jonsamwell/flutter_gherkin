import 'package:example_with_integration_test/services/external_application_manager.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

class CustomWorld extends FlutterWidgetTesterWorld {
  ExternalApplicationManager? _externalApplicationManager;

  ExternalApplicationManager get externalApplicationManager =>
      _externalApplicationManager!;

  void setExternalApplicationManager(ExternalApplicationManager manager) {
    _externalApplicationManager = manager;
  }
}
