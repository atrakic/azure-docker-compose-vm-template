#!/bin/bash
set -exo pipefail

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")
source "${SCRIPT_ROOT}"/../.env
source "${SCRIPT_ROOT}"/test-functions.sh


## Assemble required configs
# https://docs.docker.com/compose/how-tos/environment-variables/envvars/#compose_file
export COMPOSE_FILE=compose.yml:compose.override.yml

# Check if docker is running
docker compose version
docker compose config --quiet

## Build images (dont start them)
docker compose  build

## Start reverse proxy incl. main services using pinned version
API_RELEASE=latest \
    docker compose up \
    --build --remove-orphans -d

container="api"
#while ! curl -o /dev/null -sf localhost;do sleep 1; done
wait_for_healthy_container ${container}

## Test services
docker exec nginx-proxy nginx -T
docker exec letsencrypt /app/cert_status

## Simulate a new version update
curl -fisk -H "Authorization: Bearer ${WATCHTOWER_HTTP_API_TOKEN}" -H "Host: ${WATCHTOWER_VIRTUAL_HOST}" localhost/v1/update
wait_for_healthy_container ${container}
curl -fisk -H "Host: api.localhost" localhost


## Get logs
docker compose top
docker compose stats --no-stream

## Clean up
docker compose \
    down --remove-orphans -v --rmi local

docker system prune -f
