Feature: Delayed navigation

  Scenario: User can navigate to page two. Eventually
    Given I expect the "counter" to be "0"
    When I long press the "openPage2" button
    Then I expect the widget "pageTwo" to be present within 15 seconds