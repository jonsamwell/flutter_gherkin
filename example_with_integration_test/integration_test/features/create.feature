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
    Given I have item with data
      """
      {
        "glossary": {
          "title": "example glossary",
          "GlossDiv": {
            "title": "S",
            "GlossList": {
              "GlossEntry": {
                "ID": "SGML",
                "SortAs": "SGML",
                "GlossTerm": "Standard Generalized Markup Language",
                "Acronym": "SGML",
                "Abbrev": "ISO 8879:1986",
                "GlossDef": {
                  "para": "A meta-markup language, used to create markup languages such as DocBook.",
                  "GlossSeeAlso": [
                    "GML",
                    "XML"
                  ]
                },
                "GlossSee": "markup"
              }
            }
          }
        }
      }
      """
    # When I test the default step timeout is not applied to step with custom timeout