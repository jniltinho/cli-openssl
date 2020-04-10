#!/bin/sh
set -e

if [[ "$1" == 'get-ssl.py' || "$1" == 'get-ssl' ]] ; then
    exec python "$@"
    exit 0
fi


exec "$@"
