Feature: Interaction

  Scenario: Widget can be long pressed
    Given I expect the "longPressText" to be "Text that has not been long pressed"
    When I long press the "longPressText" text
    Then I expect the "longPressText" to be "Text has been long pressed!"
