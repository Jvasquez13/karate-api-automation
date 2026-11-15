Feature: Ping Test
    Scenario: Ping the server to check if it is up and running
    Given url "https://restful-booker.herokuapp.com"
    And path 'ping'
    When method GET
    Then status 201
