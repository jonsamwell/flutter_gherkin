@debug
Feature: Expect failure
  Ensure that when a test fails the exception or test failure is reported

  Scenario: Exception should be added to json report
    Given I expect the todo list
      | Todo                     |
      | Buy blueberries          |
    When I tap the "add" button
    And I fill the "todo" field with "Buy hannah's apples"

  Scenario: Failed expect() should be added to json report
    Description for this scenario!
    When I tap the "add" button
    And I fill the "todo" field with "Buy hannah's apples"
    Then I expect a failure