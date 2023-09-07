#!/bin/sh

# Abort on any error (including if wait-for-it fails).
set -e

# Wait for the backend to be up, if we know where it is.
if [ -n "$DB_HOST" ]; then
  /app/wait-for-it.sh "$DB_HOST:${DB_PORT:-3306}"
fi

# Run the main container command.
exec "$@"