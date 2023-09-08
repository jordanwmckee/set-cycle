#!/bin/sh

# Abort on any error (including if wait-for-it fails).
set -e

# Wait for the backend to be up, if we know where it is.
if [ -n "$DB_HOST" ]; then
  ./docker/wait-for-it.sh "$DB_HOST:${DB_PORT:-3306}"
fi

# set up github.com/codegangsta/gin for live reloading
if [ "$GIN_MODE" = "release" ]; then
  echo "Running in release mode"
else
  echo "Running in development mode"
  go install github.com/codegangsta/gin@latest
  go mod tidy
fi

# Run the main container command.
exec "$@"