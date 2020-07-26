Feature: Navigation

  @debug
  Scenario: User can navigate back from page two
    Given I expect the "counter" to be "0"
    When I tap the "increment" button
    Then I expect the "counter" to be "1"

    Given I tap the label that contains the text "Open page 2"
    Then I expect the text "Contents of page 2" to be present

    Given I tap the back button
    Then I expect the "counter" to be "1"