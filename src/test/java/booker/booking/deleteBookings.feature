Feature: Delete Bookings test

    Background:
        * url baseUrl

    Scenario: Delete a specific booking by ID from the API
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id

        Given path 'booking', id
        And header Cookie = 'token=' + authToken
        When method DELETE
        Then status 201

        Given path 'booking', id
        And header Accept = 'application/json'
        When method GET
        Then status 404
