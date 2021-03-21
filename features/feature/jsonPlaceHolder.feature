
Feature: Validate User details for the JSONPlaceHolder API

  @apiTest @positive
  Scenario: API should return non-empty response
    Given I set GET request api endpoint
    When I set HEADER before sending get request
  """
 	{"content_type":"application/json"}
  """
    Then I receive HTTP response code 200
    And Non-Empty Response Body is returned

  @apiTest @positive
  Scenario Outline: API should return response for the valid id
    Given I set GET request api endpoint "<id>"
    When I set HEADER before sending get request
    """
 	{"content_type":"application/json"}
    """
    Then I receive HTTP response code 200
    And Response count is "1"
    And response body should contain id as "<id>"
    Examples:
      | id |
      |1|
      |2|
      |3|

  @apiTest @positive
  Scenario Outline: API should return response for the valid user id
    Given I set GET request api endpoint
    When I set param userId as "<userId>" before sending the GET request
    Then I receive HTTP response code 200
    And Response should contain only userId "<userId>" results
    Examples:
      | userId |
      |       1|
      |       3|

  @apiTest @positive
  Scenario Outline: API should return response for the valid id
    Given I set GET request api endpoint "<id>"
    When I set HEADER before sending get request
    """
 	{"content_type":"application/json"}
    """
    Then I receive HTTP response code 200
    And Response count is "1"
    And response body should contain id as "<id>"
    Examples:
      | id |
      |1|
      |2|
      |3|

  @apiTest @negative
  Scenario Outline: API should return 404 Not Found error code for invalid id
    Given I set GET request api endpoint "<id>"
    When I send the GET request
    Then I receive HTTP response code 404
    And Response Message is
    """
    404 Not Found
    """
    Examples:
      | id|
      |476568 |
      |NotAnID|

  @apiTest @negative
  Scenario Outline: API should return empty response for the invalid user id
    Given I set GET request api endpoint
    When I set param userId as "<userId>" before sending the GET request
    Then I receive HTTP response code 200
    And Empty response body is returned

    Examples:
      | userId |
      |notAnUserID|
      |4567800    |
      |      #@$&*|

  @apiTest @negative
  Scenario: API response title should not be empty
    Given I set GET request api endpoint
    When I send the GET request
    Then I receive HTTP response code 200
    And Title field is Not-Empty in all the JSON Object



