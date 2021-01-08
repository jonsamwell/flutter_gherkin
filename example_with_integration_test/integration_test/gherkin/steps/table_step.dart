import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric givenTheTable() {
  return given1<Table, FlutterWorld>(
    'the table',
    (table, context) async {
      // do something with the table data
    },
  );
}
