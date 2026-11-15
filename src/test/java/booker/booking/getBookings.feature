Feature: Get Bookings test

    Background:
        * url baseUrl

    Scenario: Get all bookings from the API
        Given path 'booking'
        When method GET
        Then status 200
        And match response == '#array'
        And match response[0] contains {bookingid: "#number"}

    Scenario: Get a specific booking by ID from the API
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id
        Given path 'booking', id
        And header Accept = 'application/json'
        When method GET
        Then status 200
        And match response == created.requestBody
