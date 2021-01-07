Feature: Counter

  Scenario: User can increment the counter
    Given I expect the "counter" to be "0"
    When I tap the "increment" button
    Then I expect the "counter" to be "1"