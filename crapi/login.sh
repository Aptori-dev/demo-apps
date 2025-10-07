#! /usr/bin/env bash

#
# Usage: login.sh username password
#

curl -sS \
    -H "Content-Type: application/json" \
    -d "{\"email\": \"$1\", \"password\": \"$2\"}" \
    -X POST \
    "${SIFT_TARGET_URL}/identity/api/auth/login" \
    | jq -e -r '"Bearer " + .token'
