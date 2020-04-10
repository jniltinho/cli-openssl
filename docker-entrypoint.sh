#!/bin/sh
set -e

if [[ "$1" == 'get-ssl.py' ]] ; then
    exec "$@"
    exit 0
fi


exec "$@"
