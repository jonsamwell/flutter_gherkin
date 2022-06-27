import 'dart:convert';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class AttachScreenshotAfterStepHook extends Hook {
  @override
  Future<void> onAfterStep(
    World world,
    String step,
    StepResult stepResult,
  ) async {
    try {
      final screenshotData = await takeScreenshot(world);
      world.attach(screenshotData, 'image/png', step);
    } catch (e, st) {
      world.attach('Failed to take screenshot\n$e\n$st', 'text/plain', step);
    }

    return super.onAfterStep(world, step, stepResult);
  }
}

Future<String> takeScreenshot(World world) async {
  final bytes = await (world as FlutterWorld).appDriver.screenshot();

  return base64Encode(bytes);
}
