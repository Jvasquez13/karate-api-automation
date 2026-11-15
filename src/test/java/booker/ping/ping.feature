@smoke @regression
Feature: Ping Test
    Background:
        * url baseUrl
    Scenario: Ping the server to check if it is up and running
    And path 'ping'
    When method GET
    Then status 201
