#!/bin/bash
set -exo pipefail

export COMPOSE_FILE=compose.yml:compose.override.yml

docker network create proxy || true

docker compose up --build --remove-orphans --quiet-pull --no-color -d
