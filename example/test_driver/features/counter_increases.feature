Feature: Counter
  The counter should be incremented when the button is pressed.

  Scenario: Counter increases when the button is pressed
    Given I pick the colour red
    Given I expect the "counter" to be "0"
    When I tap the "increment" button 10 times
    Then I expect the "counter" to be "10"