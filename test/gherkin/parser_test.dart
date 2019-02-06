import 'package:flutter_gherkin/src/gherkin/parser.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:test/test.dart';
import '../mocks/reporter_mock.dart';

void main() {
  group("parse", () {
    test('parses simple, single scenario correctly', () async {
      final parser = GherkinParser();
      final featureContents = """
      # language: en
      Feature: The name of the feature
        A multiine line description
        Line two
        Line three

        Background: Some background
          Given I setup 1
          And I setup 2

        @smoke
        Scenario: When the user does some steps they see 'd'
          Given I do step a
          And I do step b
          And I add the comment
          '''
          A mutliline
          comment
          '''
          When I do step c
          Then I expect to see d
      """;
      final FeatureFile featureFile =
          await parser.parseFeatureFile(featureContents, "", ReporterMock());
      expect(featureFile, isNot(null));
      expect(featureFile.langauge, equals("en"));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0);
      expect(feature.name, "The name of the feature");
      expect(feature.description,
          "A multiine line description\nLine two\nLine three");
      expect(feature.tags, ["smoke"]);
      expect(feature.scenarios.length, 1);

      final background = featureFile.features.elementAt(0).background;
      expect(background.name, "Some background");
      expect(background.steps.length, 2);
      expect(background.steps.elementAt(0).name, "Given I setup 1");
      expect(background.steps.elementAt(1).name, "And I setup 2");

      final scenario = featureFile.features.elementAt(0).scenarios.elementAt(0);
      expect(scenario.name, "When the user does some steps they see 'd'");
      expect(scenario.steps.length, 5);

      final steps = scenario.steps;
      expect(steps.elementAt(0).name, "Given I do step a");
      expect(steps.elementAt(1).name, "And I do step b");
      expect(steps.elementAt(2).name, "And I add the comment");
      expect(steps.elementAt(3).name, "When I do step c");
      expect(steps.elementAt(4).name, "Then I expect to see d");

      final commentStep = steps.elementAt(2);
      expect(commentStep.multilineStrings.length, 1);
      expect(commentStep.multilineStrings.elementAt(0), "A mutliline\ncomment");
    });

    test('parses complex multi-scenario correctly', () async {
      final parser = GherkinParser();
      final featureContents = """
      # language: en
      Feature: The name of the feature
        A multiine line description
        Line two
        Line three

        Background: Some background
          Given I setup 1
          And I setup 2

        @smoke
        Scenario: When the user does some steps they see 'd'
          Given I do step a
          And I do step b
          And I add the comment
          '''
          A mutliline
          comment
          '''
          And I add the people
          | Firstname | Surname | Age | Gender |
          | Woody     | Johnson | 28  | Male   |
          | Edith     | Summers | 23  | Female |
          | Megan     | Hill    | 83  | Female |
          When I do step c
          # ignore the below step
          # When I do step c.1
          Then I expect to see d
      """;
      final FeatureFile featureFile =
          await parser.parseFeatureFile(featureContents, "", ReporterMock());
      expect(featureFile, isNot(null));
      expect(featureFile.langauge, equals("en"));
      expect(featureFile.features.length, 1);

      final feature = featureFile.features.elementAt(0);
      expect(feature.name, "The name of the feature");
      expect(feature.description,
          "A multiine line description\nLine two\nLine three");
      expect(feature.tags, ["smoke"]);
      expect(feature.scenarios.length, 1);

      final background = featureFile.features.elementAt(0).background;
      expect(background.name, "Some background");
      expect(background.steps.length, 2);
      expect(background.steps.elementAt(0).name, "Given I setup 1");
      expect(background.steps.elementAt(1).name, "And I setup 2");

      final scenario = featureFile.features.elementAt(0).scenarios.elementAt(0);
      expect(scenario.name, "When the user does some steps they see 'd'");
      expect(scenario.tags, ["smoke"]);
      expect(scenario.steps.length, 6);

      final steps = scenario.steps;
      expect(steps.elementAt(0).name, "Given I do step a");
      expect(steps.elementAt(1).name, "And I do step b");
      expect(steps.elementAt(2).name, "And I add the comment");
      expect(steps.elementAt(3).name, "And I add the people");
      expect(steps.elementAt(4).name, "When I do step c");
      expect(steps.elementAt(5).name, "Then I expect to see d");

      expect(steps.elementAt(3).table, isNotNull);
      expect(steps.elementAt(3).table.header, isNotNull);
      expect(steps.elementAt(3).table.header.columns,
          ["Firstname", "Surname", "Age", "Gender"]);
      expect(steps.elementAt(3).table.rows.elementAt(0).columns.toList(),
          ["Woody", "Johnson", "28", "Male"]);
      expect(steps.elementAt(3).table.rows.elementAt(1).columns.toList(),
          ["Edith", "Summers", "23", "Female"]);
      expect(steps.elementAt(3).table.rows.elementAt(2).columns.toList(),
          ["Megan", "Hill", "83", "Female"]);

      final commentStep = steps.elementAt(2);
      expect(commentStep.multilineStrings.length, 1);
      expect(commentStep.multilineStrings.elementAt(0), "A mutliline\ncomment");
    });
  });
}
