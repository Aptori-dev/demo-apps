#! /usr/bin/env bash
curl -sS \
    -H "Content-Type: application/json" \
    -d '{"email": "bob3@example.com", "password": "BOB456"}' \
    -X POST \
    'http://localhost:8888/identity/api/auth/login' \
    | jq -e -r '"Bearer " + .token'
