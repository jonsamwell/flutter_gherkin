import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/configuration.dart';
import 'package:flutter_gherkin/src/gherkin/exceptions/step_not_defined_error.dart';
import 'package:flutter_gherkin/src/gherkin/expressions/tag_expression.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/background.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/scenario.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/step.dart';
import 'package:flutter_gherkin/src/gherkin/steps/exectuable_step.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';
import 'package:flutter_gherkin/src/reporters/messages.dart';

class FeatureFileRunner {
  final TestConfiguration _config;
  final TagExpressionEvaluator _tagExpressionEvaluator;
  final Iterable<ExectuableStep> _steps;
  final Reporter _reporter;
  final Hook _hook;

  FeatureFileRunner(this._config, this._tagExpressionEvaluator, this._steps,
      this._reporter, this._hook);

  Future<bool> run(FeatureFile featureFile) async {
    bool haveAllFeaturesPassed = true;
    for (var feature in featureFile.features) {
      haveAllFeaturesPassed &= await _runFeature(feature);
    }

    return haveAllFeaturesPassed;
  }

  Future<bool> _runFeature(FeatureRunnable feature) async {
    bool haveAllScenariosPassed = true;
    if (_canRunFeature(_config.tagExpression, feature)) {
      try {
        await _reporter.onFeatureStarted(
            StartedMessage(Target.feature, feature.name, feature.debug));
        await _log("Attempting to running feature '${feature.name}'",
            feature.debug, MessageLevel.info);
        for (final scenario in feature.scenarios) {
          haveAllScenariosPassed &=
              await _runScenario(scenario, feature.background);
        }
      } catch (e, stacktrace) {
        await _log("Error while running feature '${feature.name}'\n$e",
            feature.debug, MessageLevel.error);
        await _reporter.onException(e, stacktrace);
        rethrow;
      } finally {
        await _reporter.onFeatureFinished(
            FinishedMessage(Target.feature, feature.name, feature.debug));
        await _log("Finished running feature '${feature.name}'", feature.debug,
            MessageLevel.info);
      }
    } else {
      await _log(
          "Ignoring feature '${feature.name}' as tag expression not satified for feature",
          feature.debug,
          MessageLevel.info);
    }

    return haveAllScenariosPassed;
  }

  bool _canRunFeature(String tagExpression, FeatureRunnable feature) {
    return tagExpression == null
        ? true
        : _tagExpressionEvaluator.evaluate(tagExpression, feature.tags);
  }

  Future<bool> _runScenario(
      ScenarioRunnable scenario, BackgroundRunnable background) async {
    World world;
    bool scenarioPassed = true;
    await _hook.onBeforeScenario(_config, scenario.name);

    if (_config.createWorld != null) {
      await _log("Creating new world for scenerio '${scenario.name}'",
          scenario.debug, MessageLevel.debug);
      world = await _config.createWorld(_config);
      await _hook.onAfterScenarioWorldCreated(world, scenario.name);
    }

    await _reporter.onScenarioStarted(
        StartedMessage(Target.scenario, scenario.name, scenario.debug));
    if (background != null) {
      await _log("Running background steps for scenerio '${scenario.name}'",
          scenario.debug, MessageLevel.info);
      for (var step in background.steps) {
        final result = await _runStep(step, world, !scenarioPassed);
        scenarioPassed = result.result == StepExecutionResult.pass;
        if (!_canContinueScenario(result)) {
          scenarioPassed = false;
          await _log(
              "Background step '${step.name}' did not pass, all remaining steps will be skiped",
              step.debug,
              MessageLevel.warning);
        }
      }
    }

    for (var step in scenario.steps) {
      final result = await _runStep(step, world, !scenarioPassed);
      scenarioPassed = result.result == StepExecutionResult.pass;
      if (!_canContinueScenario(result)) {
        scenarioPassed = false;
        await _log(
            "Step '${step.name}' did not pass, all remaining steps will be skiped",
            step.debug,
            MessageLevel.warning);
      }
    }

    world?.dispose();

    await _reporter.onScenarioFinished(
        ScenarioFinishedMessage(scenario.name, scenario.debug, scenarioPassed));
    await _hook.onAfterScenario(_config, scenario.name);
    return scenarioPassed;
  }

  bool _canContinueScenario(StepResult stepResult) {
    return stepResult.result == StepExecutionResult.pass;
  }

  Future<StepResult> _runStep(
      StepRunnable step, World world, bool skipExecution) async {
    StepResult result;
    final ExectuableStep code = _matchStepToExectuableStep(step);
    final Iterable<dynamic> parameters = _getStepParameters(step, code);

    await _log(
        "Attempting to run step '${step.name}'", step.debug, MessageLevel.info);
    await _reporter.onStepStarted(
        StepStartedMessage(Target.step, step.name, step.debug, step.table));
    if (skipExecution) {
      result = StepResult(0, StepExecutionResult.skipped);
    } else {
      result = await _runWithinTest<StepResult>(
          step.name,
          () async => code.step
              .run(world, _reporter, _config.defaultTimeout, parameters));
    }
    await _reporter
        .onStepFinished(StepFinishedMessage(step.name, step.debug, result));
    return result;
  }

  /// the idea here is that we could use this as an abstraction to run
  /// within another test framework
  Future<T> _runWithinTest<T>(String name, Future<T> fn()) async {
    // the timeout is handled indepedently from this
    final completer = Completer<T>();
    try {
      // test(name, () async {
      try {
        final result = await fn();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
      // }, timeout: Timeout.none);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  ExectuableStep _matchStepToExectuableStep(StepRunnable step) {
    final executable = _steps.firstWhere(
        (s) => s.expression.isMatch(step.debug.lineText),
        orElse: () => null);
    if (executable == null) {
      final message = """
      Step definition not found for text:

        '${step.debug.lineText}'

      File path: ${step.debug.filePath}#${step.debug.lineNumber}
      Line:      ${step.debug.lineText}

      ---------------------------------------------

      You must implement the step:

      /// The 'Given' class can be replaced with 'Then', 'When' 'And' or 'But'
      /// All classes can take up to 5 input parameters anymore and you should probably us a table
      /// For example: `When4<String, bool, int, num>`
      /// You can also specify the type of world context you want
      /// `When4WithWorld<String, bool, int, num, MyWorld>`
      class Given_${step.debug.lineText.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')} extends Given1<String> {
        @override
        RegExp get pattern => RegExp(r"${step.debug.lineText}");

        @override
        Future<void> executeStep(String input1) async {
          // If the step is "Given I do a 'windy pop'"
          // in this example input1 would equal 'windy pop'

          // your code...
        }
      }
      """;
      _reporter.message(message, MessageLevel.error);
      throw GherkinStepNotDefinedException(message);
    }

    return executable;
  }

  Iterable<dynamic> _getStepParameters(StepRunnable step, ExectuableStep code) {
    Iterable<dynamic> parameters =
        code.expression.getParameters(step.debug.lineText);
    if (step.multilineStrings.isNotEmpty) {
      parameters = parameters.toList()..addAll(step.multilineStrings);
    }

    if (step.table != null) {
      parameters = parameters.toList()..add(step.table);
    }

    return parameters;
  }

  Future<void> _log(String message, RunnableDebugInformation context,
      MessageLevel level) async {
    await _reporter.message(
        "$message # ${context.filePath}:${context.lineNumber}", level);
  }
}
