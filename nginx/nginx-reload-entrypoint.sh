#!/usr/bin/env bash

# This makes nginx reload its configuration (and certificates) every six hours in the background and launches nginx in the foreground
while :; do sleep 6m & wait ${!}; nginx -s reload; done & nginx -g "daemon off;"

# Execute the rest of your ENTRYPOINT and CMD as expected.

exec "$@"
