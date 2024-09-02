#!/bin/bash
set -exo pipefail

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")

source "${SCRIPT_ROOT}"/../.env
source "${SCRIPT_ROOT}"/test-functions.sh

# Check if docker is running
docker compose version
docker compose config --quiet

## Build the images
docker compose \
    -f ollama-compose.yml \
    -f sonarqube-compose.yml \
    -f monitoring-compose.yml build

## Start reverse proxy incl. our services using some pinned version
API_RELEASE=latest \
    docker compose \
    -f docker-compose.yml \
    -f apps.yml up \
    --build --remove-orphans -d

container="api"
#while ! curl -o /dev/null -sf localhost;do sleep 1; done
wait_for_healthy_container ${container}

## Test services
docker exec nginx-proxy nginx -T
docker exec letsencrypt /app/cert_status

docker compose -f docker-compose.yml -f apps.yml top
docker compose -f docker-compose.yml -f apps.yml stats --no-stream

# Simulate a new version update
curl -fisk -H "Authorization: Bearer ${WATCHTOWER_HTTP_API_TOKEN}" -H "Host: watchtower.localhost" localhost/v1/update
wait_for_healthy_container ${container}
curl -fisk -H "Host: api.localhost" localhost

# Clean up
docker compose \
    -f ollama-compose.yml \
    -f sonarqube-compose.yml \
    -f monitoring-compose.yml \
    -f apps.yml \
    -f docker-compose.yml down --remove-orphans -v --rmi local
