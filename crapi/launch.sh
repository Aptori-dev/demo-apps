#! /bin/bash

# Use "docker" or "nerdctl" as the container engine tool
CE="docker"
#CE="nerdctl --namespace crapi"

${CE} compose pull
${CE} compose -f docker-compose.yml up -d

echo "Waiting for services to start..."
sleep 15
nc -vz localhost 8888 || { echo "Unable to connect to API..."; exit 1; }

# Create two users: Alice, Bob
echo
echo "Creating users..."
curl -X POST "http://localhost:8888/identity/api/auth/signup" \
    -H "Content-Type: application/json" \
    -d '{"email": "alice5@example.com", "name": "Alice", "number": "1234567890", "password": "ALICE123"}'
echo
curl -X POST "http://localhost:8888/identity/api/auth/signup" \
    -H "Content-Type: application/json" \
    -d '{"email": "bob3@example.com", "name": "Bob", "number": "9876543210", "password": "BOB456"}'
echo

# Verify login scripts used as auth plugins for Sift
./login-alice.sh
./login-bob.sh
sleep 5

# Restart all of the services to initialize database
${CE} compose restart
sleep 15


# Check that Order request succeeds
statusCode=$(curl -sSL -H "Authorization: $(./login-alice.sh)" --write-out '%{http_code}' --output /dev/null  http://localhost:8888/workshop/api/shop/orders/1)
if [ "$statusCode" -ne 200 ]; then
    echo "Unable to get Order with user Alice: status=${statusCode}"
    exit 1
fi

statusCode=$(curl -sSL -H "Authorization: $(./login-alice.sh)" --write-out '%{http_code}' --output /dev/null  http://localhost:8888/identity/api/v2/vehicle/vehicles)
if [ "$statusCode" -ne 200 ]; then
    echo "Unable to get Vehicles with user Alice: status=${statusCode}"
    exit 1
fi

echo "Getting Alice's vehicles"
curl -i -H "Authorization: $(./login-alice.sh)" http://localhost:8888/identity/api/v2/vehicle/vehicles


# VIN and pincode are sent by email to Mailhog (http://localhost:8025)
#
# curl -X POST "http://localhost:8888/identity/api/v2/vehicle/add_vehicle" \
#     -H "Authorization: $(./login-alice.sh)" \
#     -H "Content-Type: application/json" \
#     -d '{"vin": "4LXBZ92IOHV549056", "pincode": "3526"}'
# 
# curl -X POST "http://localhost:8888/identity/api/v2/vehicle/add_vehicle" \
#     -H "Authorization: $(./login-bob.sh)" \
#     -H "Content-Type: application/json" \
#     -d '{"vin": "1HTVZ39BAZE677317", "pincode": "7524"}'

