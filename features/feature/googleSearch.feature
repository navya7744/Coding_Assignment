@TC_Google_Search
Feature: 'When I go to the Google, and search for a keyword,
  I expect to see some reference to that keyword in the result summary.'

  @scenario_1
  Scenario Outline: Keyword search in google
    Given I navigate to google search page
    When I type the "<Keyword>" in google search bar
    And Click on search results
    Then The page title should contain "<Keyword>"
    And Displayed results should contain "<Keyword>"

    Examples: 
      |Keyword|
      |duck|
