@tag
Feature: Creating todos

  @tag1 @tag_two
  Scenario: User can create a new todo item
    Given I fill the "todo" field with "Buy carrots"
    When I tap the 'add' button
    Then I expect the todo list
      | Todo        |
      | Buy carrots |

  @debug
  Scenario: User can create multiple new todo items
    Given I fill the "todo" field with "Buy carrots"
    When I tap the "add" button
    And I fill the "todo" field with "Buy apples"
    When I tap the "add" button
    And I fill the "todo" field with "Buy blueberries"
    When I tap the "add" button
    Then I expect the todo list
      | Todo            |
      | Buy blueberries |
      | Buy apples      |
      | Buy carrots     |
    Given I wait 5 seconds for the animation to complete
    # When I test the default step timeout is not applied to step with custom timeout