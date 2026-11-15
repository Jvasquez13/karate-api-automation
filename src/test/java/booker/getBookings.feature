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
        Given path 'booking'
        When method GET
        Then status 200
        * def id = response[1].bookingid
        Given path 'booking', id
        And header Accept = 'application/json'
        When method GET
        Then status 200
        And match response.firstname == '#string'
        And match response.lastname == '#string'
        And match response.totalprice == '#number'
        And match response.depositpaid == '#boolean'
        And match response.bookingdates.checkin == '#string'
        And match response.bookingdates.checkout == '#string'
        And match response.additionalneeds == '##string'
