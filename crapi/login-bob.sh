#! /usr/bin/env bash
curl -sS \
    -H "Content-Type: application/json" \
    -d '{"email": "bob3@example.com", "password": "BOB456"}' \
    -X POST \
    "${SIFT_TARGET_URL}/identity/api/auth/login" \
    | jq -e -r '"Bearer " + .token'
