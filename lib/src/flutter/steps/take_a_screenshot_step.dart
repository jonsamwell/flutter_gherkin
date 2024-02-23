import 'dart:convert';

import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric takeScreenshot() {
  return given1<String, FlutterWorld>(
    'I take a screenshot called {String}',
    (name, context) async {
      final bytes = await context.world.appDriver.screenshot(
        screenshotName: name,
      );

      context.world.attach(base64Encode(bytes), 'image/png');
    },
  );
}
