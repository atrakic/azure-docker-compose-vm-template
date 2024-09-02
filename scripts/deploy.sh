#!/bin/bash
set -exo pipefail

docker network create proxy || true
docker compose \
    -f docker-compose.yml \
    -f apps.yml \
    up --remove-orphans --no-color -d
