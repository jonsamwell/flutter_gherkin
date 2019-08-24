Feature: Counter
  The counter should be incremented when the button is pressed.

  @scenario_outline
  Scenario Outline: Counter increases when the button is pressed
    Given I pick the colour red
    Given I expect the "counter" to be "0"
    When I tap the "increment" button <tap_amount> times
    Then I expect the "counter" to be "<tap_amount>"

    Examples:
      | tap_amount |
      | 1          |
      | 2          |
      | 5          |
      | 10         |