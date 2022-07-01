import 'dart:convert';

import 'package:gherkin/gherkin.dart';
import '../world/flutter_world.dart';

class AttachScreenshotOnFailedStepHook extends Hook {
  @override
  Future<void> onAfterStep(
    World world,
    String step,
    StepResult stepResult,
  ) async {
    if (stepResult.result == StepExecutionResult.fail ||
        stepResult.result == StepExecutionResult.error ||
        stepResult.result == StepExecutionResult.timeout) {
      try {
        final screenshotData = await _takeScreenshot(world);
        world.attach(screenshotData, 'image/png', step);
      } catch (e, st) {
        world.attach('Failed to take screenshot\n$e\n$st', 'text/plain', step);
      }
    }
  }

  Future<String> _takeScreenshot(World world) async {
    final bytes = await (world as FlutterWorld).appDriver.screenshot();

    return base64Encode(bytes);
  }
}
