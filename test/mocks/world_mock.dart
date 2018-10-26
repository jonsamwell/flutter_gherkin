import 'package:flutter_gherkin/flutter_gherkin.dart';

class WorldMock extends World {
  bool disposeFnInvoked = false;

  @override
  void dispose() => disposeFnInvoked = true;
}
