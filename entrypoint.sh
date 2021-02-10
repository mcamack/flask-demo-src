#!/bin/sh

if [ "$FLASK_ENV" = "dev" ]; then
    echo "Running in Dev mode"
fi

if [ "$FLASK_ENV" = "prod" ]; then
    echo "Running in Production mode with Gunicorn server"
fi

exec "$@"