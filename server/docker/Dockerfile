# Only use this script if you want to build the app in a container, 
# otherwise use the mounted volume in the docker-compose file
FROM golang:latest

WORKDIR /app

COPY app/go.mod app/go.sum ./
RUN go mod download

COPY app .

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /sets-app

EXPOSE 8080

# Add wait-for-it
COPY docker/wait-for-it.sh docker/docker-entrypoint.sh ./
RUN chmod +x ./wait-for-it.sh ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["go", "run", "main.go"]