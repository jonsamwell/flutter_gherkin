Feature: Counter

  @tag1 @tag_two
  Scenario: User can increment the counter
    Given I expect the "counter" to be "0"
    When I tap the "increment" button
    Then I expect the "counter" to be "1"
    Given the table
      | Header One | Header Two | Header Three |
      | 1          | 2          | 3            |
      | 4          | 5          | 6            |