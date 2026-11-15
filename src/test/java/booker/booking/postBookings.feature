@smoke @regression
Feature: Creation of Bookings

    Background:
        * url baseUrl

    Scenario: Create a new booking in the API
        Given path 'booking'
        And header Accept = 'application/json'
        * def requestBody =
        """
        {
            "firstname": "John",
            "lastname": "Doe",
            "totalprice": 150,
            "depositpaid": true,
            "bookingdates": {
                "checkin": "2023-01-01",
                "checkout": "2023-01-10"
            },
            "additionalneeds": "Breakfast"
        }
        """
        And request requestBody
        When method POST
        Then status 200
        And match response.bookingid == '#number'
        And match response.booking == requestBody
