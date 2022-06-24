import 'package:flutter/material.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

final thenIExpectTheTodos = then1<GherkinTable, FlutterWorld>(
  'I expect the todo list',
  (table, context) async {
    expect(context.configuration.timeout, isNotNull);
    expect(context.configuration.timeout!.inSeconds, 5);

    await context.world.appDriver.waitForAppToSettle();

    // get the parent list
    final listTileFinder = context.world.appDriver.findBy(
      ListTile,
      FindType.type,
    );

    for (final row in table.rows) {
      final todoText = row.columns.elementAt(0);
      final listTileTextFinder = context.world.appDriver.findBy(
        todoText,
        FindType.text,
      );
      // find the todo by the expected text
      final finder = await context.world.appDriver
          .findByDescendant(listTileFinder, listTileTextFinder);

      final text = await context.world.appDriver.getText(finder);

      context.expect(todoText, text);
    }
  },
  configuration: StepDefinitionConfiguration()
    ..timeout = const Duration(seconds: 5),
);
