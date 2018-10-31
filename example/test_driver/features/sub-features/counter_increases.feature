Feature: Counter
  The counter should be incremented when the button is pressed.

  @perf
  Scenario: Counter increases when the button is pressed
    Given I expect the "counter" to be "0"
    When I tap the "increment" button 20 times
    Then I expect the "counter" to be "20"