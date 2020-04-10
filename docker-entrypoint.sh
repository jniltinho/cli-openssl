#!/bin/sh
set -e

if [ "$1" = 'get-ssl' ]; then
    exec python /usr/local/bin/get-ssl.py "$@"
fi

exec "$@"
