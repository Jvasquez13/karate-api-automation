# karate-api-automation

API test automation with **Karate DSL**, **Java 17** and **Maven**, run against the public [Restful-Booker](https://restful-booker.herokuapp.com) practice API.

The goal of this project is to show a clean, readable API test suite: chained requests, schema-style validation with fuzzy matching, shared configuration and authentication.

## Tech stack

| Tool | Version | Purpose |
|---|---|---|
| Karate DSL (`karate-junit5`) | 1.5.0 | API test framework |
| Java | 17 | Runtime |
| Maven | 3.x | Build and test execution |
| JUnit 5 | via Karate | Test runner |

## What is covered

| Feature | Endpoint | What it checks |
|---|---|---|
| `ping.feature` | `GET /ping` | Health check returns `201` |
| `auth.feature` | `POST /auth` | Credentials sent as JSON, status `200`, `token` is a string |
| `postBookings.feature` | `POST /booking` | Status `200`, `bookingid` is a number, the stored booking equals the one sent |
| `getBookings.feature` | `GET /booking` | Response is an array; a newly created booking appears in the list |
| `getBookings.feature` | `GET /booking?firstname=&lastname=` | Filtering by name returns the created booking |
| `getBookings.feature` | `GET /booking/{id}` | Booking created in the test itself; the response equals what was sent |
| `getBookings.feature` | `GET /booking/{id}` (negative) | Unknown or invalid ids return `404` (data-driven with `Scenario Outline`) |
| `putBooking.feature` | `PUT /booking/{id}` | Update with the auth token, every field is updated |
| `putBooking.feature` | `PUT /booking/{id}` (negative) | Missing token returns `403` |
| `deleteBookings.feature` | `DELETE /booking/{id}` | Delete with the auth token (`201`), then `GET` returns `404` |
| `deleteBookings.feature` | `DELETE /booking/{id}` (negative) | Missing or invalid token returns `403` |

Each endpoint has one feature with its positive and negative scenarios. Each test creates its own booking through a reusable helper (`common/create-booking.feature`), so scenarios do not depend on data left by others. Bookings created by negative tests are deleted at the end of the scenario.

### Notes from testing the API
- `GET /booking/{id}` answers `418 I'm a Teapot` unless the `Accept: application/json` header is sent, even though the documentation lists a default value. The tests send the header explicitly.
- `additionalneeds` is not present in every booking, so it is validated as optional (`'##string'`).

## Project structure

```
.
├── pom.xml
└── src/test/java
    ├── karate-config.js          # base URL, credentials and shared auth token
    ├── common
    │   └── create-booking.feature   # reusable setup: creates a booking and returns its id
    └── booker
        ├── BookerTest.java       # JUnit 5 runner, executes every feature below
        ├── ping/ping.feature
        ├── auth/auth.feature
        └── booking
            ├── postBookings.feature
            ├── getBookings.feature
            ├── putBooking.feature
            └── deleteBookings.feature
```

`logback-test.xml` (next to `karate-config.js`) controls the log output.

## Configuration

`karate-config.js` defines the variables available in every feature:

| Variable | Description |
|---|---|
| `baseUrl` | Base URL of the API under test |
| `username` / `password` | Credentials for `POST /auth` |

The credentials are the public ones published in the Restful-Booker documentation. For a real project, read them from environment variables or system properties instead of committing them.

## Running the tests

Requirements: JDK 17 or newer and Maven.

```bash
mvn test
```

After the run, open the HTML report:

```
target/karate-reports/karate-summary.html
```

## Reports and CI

Every push to `main` runs the suite on GitHub Actions (`.github/workflows/ci.yml`) and publishes:

- an **Allure report** on GitHub Pages,
- the **Karate HTML report** and the Allure report as downloadable artifacts of each run.

To see the Allure dashboard locally (requires Docker):

```bash
mvn test
docker compose up
```

Then open `http://localhost:5050/allure-docker-service/latest-report`.

## Roadmap

- [x] Full CRUD flow (create, update, delete a booking) using the auth token
- [x] CI pipeline with GitHub Actions and Allure report
- [x] Negative tests (`404`, `403`)
- [x] Data-driven scenarios with `Scenario Outline`
- [ ] Tags (`@smoke`, `@regression`) and running subsets from the runner
- [ ] Negative tests for invalid request bodies (`400`)
