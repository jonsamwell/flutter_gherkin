@tag
Feature: Creating todos

  Scenario: User can create single todo item
    Given I fill the "todo" field with "Buy spinach"
    When I tap the "add" button
    Then I expect the todo list
      | Todo        |
      | Buy spinach |
    When I take a screenshot called 'Johnson'

  Scenario: User can create multiple new todo items
    Given I fill the "todo" field with "Buy carrots"
    When I tap the "add" button
    And I fill the "todo" field with "Buy hannah's apples"
    When I tap the "add" button
    And I fill the "todo" field with "Buy blueberries"
    When I tap the "add" button
    Then I expect the todo list
      | Todo                     |
      | Buy blueberries          |
      | Buy hannah's apples      |
      | Buy carrots              |
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