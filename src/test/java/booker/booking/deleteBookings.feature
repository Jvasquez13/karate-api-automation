@regression
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

    @negative
    Scenario: Delete a booking without a token is forbidden
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id
        Given path 'booking', id
        When method DELETE
        Then status 403

        # clean up the booking created for this scenario
        Given path 'booking', id
        And header Cookie = 'token=' + authToken
        When method DELETE
        Then status 201

    @negative
    Scenario: Delete a booking with an invalid token is forbidden
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id
        Given path 'booking', id
        And header Cookie = 'token=invalid-token'
        When method DELETE
        Then status 403

        # clean up the booking created for this scenario
        Given path 'booking', id
        And header Cookie = 'token=' + authToken
        When method DELETE
        Then status 201
