# Server Information

This server is comprised of a RESTful api written in 'go', and a MySQL database.

To run everything, you need to navigate to [/server/database](https://github.com/jordanwmckee/sets-app/server/database) and run

```bash
docker-compose up
```

<sub>Note: the mysql container will fail if the mounted directory is nonempty</sub>

This will start and initialize the database with the configuration in the `init.sql` file.

Once the database is running, the rest api can be started by navigating to [/server](https://github.com/jordanwmckee/sets-app/server) and running

```bash
go run main.go
```

<sub>More info can be found on initial setup at [https://seefnasrul.medium.com/create-your-first-go-rest-api-with-jwt-authentication-in-gin-framework-dbe5bda72817](https://seefnasrul.medium.com/create-your-first-go-rest-api-with-jwt-authentication-in-gin-framework-dbe5bda72817)</sub>
