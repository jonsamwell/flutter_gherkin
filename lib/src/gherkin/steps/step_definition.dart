import 'package:flutter_gherkin/src/gherkin/exceptions/parameter_count_mismatch_error.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';
import 'package:flutter_gherkin/src/reporters/reporter.dart';
import 'package:flutter_gherkin/src/utils/perf.dart';
import 'package:test/test.dart';
import 'dart:async';

abstract class StepDefinitionGeneric<TWorld extends World> {
  final StepDefinitionConfiguration config;
  final int _expectParameterCount;
  TWorld _world;
  Reporter _reporter;
  Duration _timeout;
  RegExp get pattern;

  StepDefinitionGeneric(this.config, this._expectParameterCount) {
    this._timeout = this.config?.timeout;
  }

  TWorld get world => _world;
  Duration get timeout => _timeout;
  Reporter get reporter => _reporter;

  Future<StepResult> run(TWorld world, Reporter reporter,
      Duration defaultTimeout, Iterable<dynamic> parameters) async {
    _ensureParameterCount(parameters.length, _expectParameterCount);
    int elapsedMilliseconds;
    try {
      await Perf.measure(() async {
        _world = world;
        _reporter = reporter;
        _timeout = _timeout ?? defaultTimeout;
        final result = await onRun(parameters).timeout(_timeout);
        return result;
      }, (ms) => elapsedMilliseconds = ms);
    } on TestFailure catch (tf) {
      return StepResult(
          elapsedMilliseconds, StepExecutionResult.fail, tf.message);
    } on TimeoutException catch (te, st) {
      return ErroredStepResult(
          elapsedMilliseconds, StepExecutionResult.timeout, te, st);
    } catch (e, st) {
      return ErroredStepResult(
          elapsedMilliseconds, StepExecutionResult.error, e, st);
    }

    return StepResult(elapsedMilliseconds, StepExecutionResult.pass);
  }

  Future<void> onRun(Iterable<dynamic> parameters);

  void _ensureParameterCount(int actual, int expected) {
    if (actual != expected)
      throw GherkinStepParameterMismatchException(
          this.runtimeType, expected, actual);
  }
}
