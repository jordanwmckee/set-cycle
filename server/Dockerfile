FROM golang:1.19.0

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download

EXPOSE 8080

RUN go mod tidy