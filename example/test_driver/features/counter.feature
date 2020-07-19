Feature: Startup

  Scenario: should increment counter
    Given I expect the "counter" to be "0"
    When I tap the "increment" button
    And I tap the "increment" button
    Then I expect the "counter" to be "2"

  Scenario: counter should reset when app is restarted
    Given I expect the "counter" to be "0"
    When I tap the "increment" button
    Then I expect the "counter" to be "1"
    When I restart the app
    Then I expect the "counter" to be "0"
