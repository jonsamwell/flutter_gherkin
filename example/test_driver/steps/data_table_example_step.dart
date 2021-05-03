import 'package:gherkin/gherkin.dart';

/// This step expects a data table
///
/// For example:
///
/// `Given I add the users`
///  | Firstname | Surname | Age | Gender |
///  | Woody     | Johnson | 28  | Male   |
///  | Edith     | Summers | 23  | Female |
///  | Megan     | Hill    | 83  | Female |
StepDefinitionGeneric WhenIAddTheUsers() {
  return when1(
    'I add the users',
    (GherkinTable dataTable, context) async {
      for (var row in dataTable.rows) {
        // do something with row
        row.columns.forEach((columnValue) => print(columnValue));
      }
    },
  );
}
