@smoke @regression
Feature: Auth steps for consume the api

    Background:
        * url baseUrl

    Scenario: Create a new auth token
        Given path 'auth'
        And request { username: '#(username)', password: '#(password)' }
        When method POST
        Then status 200
        And print response
        And match response.token == '#string'
        * def token = response.token
