@tag
Feature: Creating todos

  @tag1 @tag_two
  Scenario: User can create a new todo item
    Given I fill the "todo" field with "Buy carrots"
    When I tap the 'add' button
    Then I expect the todo list
      | Todo        |
      | Buy carrots |

  Scenario: User can create multiple new todo items
    Given I fill the "todo" field with "Buy carrots"
    When I tap the "add" button
    Given I fill the "todo" field with "Buy apples"
    When I tap the "add" button
    Given I fill the "todo" field with "Buy blueberries"
    When I tap the "add" button
    Then I expect the todo list
      | Todo            |
      | Buy blueberries |
      | Buy apples      |
      | Buy carrots     |