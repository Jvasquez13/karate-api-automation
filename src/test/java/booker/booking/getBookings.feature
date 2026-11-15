@regression
Feature: Get Bookings test

    Background:
        * url baseUrl

    @smoke
    Scenario: Get all bookings from the API
        Given path 'booking'
        When method GET
        Then status 200
        And match response == '#array'
        And match response[0] contains {bookingid: "#number"}

    Scenario: A newly created booking appears in the list
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id
        Given path 'booking'
        When method GET
        Then status 200
        And match response contains {bookingid: '#(id)'}

    Scenario: Filter bookings by first and last name
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id
        Given path 'booking'
        And param firstname = created.requestBody.firstname
        And param lastname = created.requestBody.lastname
        When method GET
        Then status 200
        And match response contains {bookingid: '#(id)'}

    @smoke
    Scenario: Get a specific booking by ID from the API
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id
        Given path 'booking', id
        And header Accept = 'application/json'
        When method GET
        Then status 200
        And match response == created.requestBody

    @negative
    Scenario: Get a booking that does not exist
        Given path 'booking', 999999999
        And header Accept = 'application/json'
        When method GET
        Then status 404

    @negative
    Scenario Outline: Get a booking with an invalid id (<id>)
        Given path 'booking', '<id>'
        And header Accept = 'application/json'
        When method GET
        Then status 404

        Examples:
            | id  |
            | 0   |
            | -1  |
            | abc |
