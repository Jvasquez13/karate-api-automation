Feature: Update Booking test
    Background:
        * url baseUrl
        * def created = call read('classpath:common/create-booking.feature')
        * def id = created.id

    Scenario: Update a specific booking by ID from the API
        Given path 'booking', id
        And header Accept = 'application/json'
        And header Content-Type = 'application/json'
        And header Cookie = 'token=' + authToken
        * def requestBody =
        """
        {
            "firstname": "Jane",
            "lastname": "Smith",
            "totalprice": 200,
            "depositpaid": false,
            "bookingdates": {
                "checkin": "2023-02-01",
                "checkout": "2023-02-10"
            },
            "additionalneeds": "Lunch"
        }
        """
        And request requestBody
        When method PUT
        Then status 200
        And match response.firstname == 'Jane'
        And match response.lastname == 'Smith'
        And match response.totalprice == 200
        And match response.depositpaid == false
        And match response.bookingdates.checkin == '2023-02-01'
        And match response.bookingdates.checkout == '2023-02-10'
        And match response.additionalneeds == 'Lunch'