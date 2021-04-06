import 'dart:convert';

import 'package:gherkin/gherkin.dart';
import 'package:meta/meta.dart';
import '../flutter_world.dart';

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
        final screenshotData = await takeScreenshot(world);
        world.attach(screenshotData, 'image/png', step);
      } catch (e, st) {
        world.attach('Failed to take screenshot\n$e\n$st', 'text/plain', step);
      }
    }
  }

  @protected
  Future<String> takeScreenshot(World world) async {
    final bytes = await (world as FlutterWorld).driver!.screenshot();

    return base64Encode(bytes);
  }
}
