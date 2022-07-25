@tag
Feature: Swiping

  Scenario: User can swipe cards left and right
    Given I swipe right by 250 pixels on the "scrollable cards"`
    Then I expect the text "Page 2" to be present
    
    Given I swipe left by 250 pixels on the "scrollable cards"`
    Then I expect the text "Page 1" to be present