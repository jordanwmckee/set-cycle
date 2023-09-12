# Server Information

This server is comprised of a RESTful api written in 'go', and a MySQL database.

To run everything, you need to navigate to [/server](https://github.com/jordanwmckee/sets-app/server) and run

```bash
docker-compose up
```

<sub>Note: the mysql container may fail if the mounted `mysql-data` directory is nonempty</sub>

This will start and initialize the database with the configuration in the `init.sql` file. It will also
start the `go` api once the container is able to connect to the mysql container, using the `wait-for-it.sh`
script.

## Some notes on Authorization flow

Here's a basic breakdown of how auth is handled in the application.

1. User does "Sign in with Apple", which returns a unique apple_user_id identifier to be used by the db to locate users
2. The /authenticate endpoint will return a token pair of refresh/access tokens for the authenticated user, where they are bound to the user by embedding their apple_user_id into the token attributes. The refresh token does not expire and is to be stored in ios keychain, and the access token is stored in UserDefaults. If a record for that user exists in the db, it will "log them in", else it will "register" them as a new user. The `users` db table is set with a primary key of apple_user_id, and this id is referenced in the `plans` table to bind the plans to their users.

<sub>More info can be found on initial setup for rest api at [https://seefnasrul.medium.com/create-your-first-go-rest-api-with-jwt-authentication-in-gin-framework-dbe5bda72817](https://seefnasrul.medium.com/create-your-first-go-rest-api-with-jwt-authentication-in-gin-framework-dbe5bda72817)</sub>
