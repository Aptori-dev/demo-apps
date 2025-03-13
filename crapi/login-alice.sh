#! /usr/bin/env bash
curl -sS \
    -H "Content-Type: application/json" \
    -d '{"email": "alice5@example.com", "password": "ALICE123"}' \
    -X POST \
    'http://localhost:8888/identity/api/auth/login' \
    | jq -e -r '"Bearer " + .token'
