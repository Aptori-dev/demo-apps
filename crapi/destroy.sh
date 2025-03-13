#! /bin/bash

#
# WARNING: If you are using "docker", it does not support namespaces.  This
#          script may delete all volumes.  You probably don't want that if
#          you are using Docker to run containers in addition to crapi.
# 

# Use "docker" or "nerdctl" as the container engine tool
CE="docker"
#CE="nerdctl --namespace crapi"

${CE} compose -f docker-compose.yml down
sleep 5
${CE} volume rm $( ${CE} volume ls --filter directory=crapi --format "{{.Name}}" )

