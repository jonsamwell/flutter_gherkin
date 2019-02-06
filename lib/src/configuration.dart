import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition_implementations.dart';
import 'package:flutter_gherkin/src/gherkin/steps/world.dart';
import 'package:flutter_gherkin/src/hooks/hook.dart';
import 'package:flutter_gherkin/src/reporters/reporter.dart';
import 'package:glob/glob.dart';

typedef Future<World> CreateWorld(TestConfiguration config);

enum ExecutionOrder { sequential, random }

class TestConfiguration {
  /// The glob path(s) to all the features
  Iterable<Glob> features;

  /// The default feature language
  String featureDefaultLanguage = "en";

  /// a filter to limit the features that are run based on tags
  /// see https://docs.cucumber.io/cucumber/tag-expressions/ for expression syntax
  String tagExpression;

  /// The default step timeout - this can be override when definition a step definition
  Duration defaultTimeout = const Duration(seconds: 10);

  /// The execution order of features - this default to random to avoid any inter-test depedencies
  ExecutionOrder order = ExecutionOrder.random;

  /// The user defined step definitions that are matched with written steps in the features
  Iterable<StepDefinitionBase> stepDefinitions;

  /// Any user defined step parameters
  Iterable<CustomParameter<dynamic>> customStepParameterDefinitions;

  /// Hooks that are run at certain points in the execution cycle
  Iterable<Hook> hooks;

  /// a list of reporters to use.
  /// Built-in reporters:
  ///   - StdoutReporter
  ///
  /// Custom reporters can be created by extending (or implementing) Reporter.dart
  Iterable<Reporter> reporters;

  /// An optional function to create a world object for each scenario.
  CreateWorld createWorld;

  /// the program will exit after all the tests have run
  bool exitAfterTestRun = true;

  /// used to allow for custom configuration to ensure framework specific congfiguration is in place
  void prepare() {}
}
