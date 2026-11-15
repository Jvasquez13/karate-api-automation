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
| `getBookings.feature` | `GET /booking` | Status `200`, response is an array, `bookingid` is a number |
| `getBookings.feature` | `GET /booking/{id}` | Chained call using an id taken from the list; validates every field type (`firstname`, `lastname`, `totalprice`, `depositpaid`, `bookingdates`, optional `additionalneeds`) |
| `auth.feature` | `POST /auth` | Credentials sent as JSON, status `200`, `token` is a string |

### Notes from testing the API
- `GET /booking/{id}` answers `418 I'm a Teapot` unless the `Accept: application/json` header is sent, even though the documentation lists a default value. The tests send the header explicitly.
- `additionalneeds` is not present in every booking, so it is validated as optional (`'##string'`).

## Project structure

```
.
├── pom.xml
└── src/test/java
    ├── karate-config.js          # base URL and credentials, shared by all features
    └── booker
        ├── BookerTest.java       # JUnit 5 runner, executes every feature in this folder
        ├── ping.feature
        ├── auth.feature
        └── getBookings.feature
```

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

## Roadmap

- [ ] Full CRUD flow (create, update, delete a booking) using the auth token
- [ ] Negative tests (`404`, `400`, `403`)
- [ ] Data-driven scenarios with `Scenario Outline`
- [ ] Tags (`@smoke`, `@regression`)
- [ ] CI pipeline with GitHub Actions
