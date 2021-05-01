import 'package:example_with_integration_test/main.dart';
import 'package:example_with_integration_test/services/external_application_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:gherkin/gherkin.dart';

import 'hooks/reset_app_hook.dart';
import 'steps/expect_todos_step.dart';
import 'steps/when_await_animation.dart';
import 'steps/when_step_has_timeout.dart';
import 'world/custom_world.dart';

FlutterTestConfiguration gherkinTestConfiguration =
    FlutterTestConfiguration.DEFAULT(
  [
    thenIExpectTheTodos,
    whenAnAnimationIsAwaited,
    whenStepHasTimeout,
  ],
)
      // ..tagExpression = '@debug'
      ..hooks = [
        ResetAppHook(),
      ]
      ..reporters = [
        StdoutReporter(MessageLevel.error)
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        ProgressReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        TestRunSummaryReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        JsonReporter(
          writeReport: (_, __) => Future<void>.value(),
        ),
      ]
      ..createWorld = (config) => Future.value(CustomWorld());

void Function(World) appInitializationFn = (World world) {
  // ensure a new injector instance is created each time
  final injector = Injector(DateTime.now().microsecondsSinceEpoch.toString());
  final externalApplicationManager = ExternalApplicationManager(injector);
  (world as CustomWorld)
      .setExternalApplicationManager(externalApplicationManager);

  runApp(
    TodoApp(
      injector: injector,
      externalApplicationManager: externalApplicationManager,
    ),
  );
};
