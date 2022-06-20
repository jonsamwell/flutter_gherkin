import 'package:gherkin/gherkin.dart';

final givenTheData = given1(
  'I have item with data',
  (jsonString, context) async {
    // print(jsonString);
  },
  configuration: StepDefinitionConfiguration()
    ..timeout = const Duration(seconds: 5),
);
