Feature: Expect failures
  Ensure that when a test fails the exception or test failure is reported

  @failure-expected
  Scenario: Exception should be added to json report
    When I tap the "button is not here but exception should be logged in report" button

  @failure-expected
  Scenario: Failed expect() should be added to json report
    Description for this scenario!
    When I tap the "add" button
    And I fill the "todo" field with "Buy hannah's apples"
    Then I expect a failure