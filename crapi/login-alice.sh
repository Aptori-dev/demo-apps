#! /usr/bin/env bash
curl -sS \
    -H "Content-Type: application/json" \
    -d '{"email": "alice5@example.com", "password": "ALiCE&123"}' \
    -X POST \
    "${SIFT_TARGET_URL}/identity/api/auth/login" \
    | jq -e -r '"Bearer " + .token'
