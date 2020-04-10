#!/bin/sh
set -e

if [ "$1" = 'get-ssl.py' ]; then
    exec python "$@"
fi

exec "$@"
