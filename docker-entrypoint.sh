#!/bin/sh
set -e

if [[ "$1" == 'get-ssl.py' ]] ; then
    exec python "$@"
    exit 0
fi


exec "$@"
