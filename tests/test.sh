#!/bin/bash

set -e

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")

container="api"
token="a55fab18d2466e18"

source "${SCRIPT_ROOT}"/test-functions.sh

docker compose version
docker compose config --quiet

docker compose -f docker-compose.yml -f apps.yml up --build --remove-orphans -d
docker compose -f docker-compose.yml -f apps.yml ps -a

docker exec nginx-proxy nginx -T

#while ! curl -o /dev/null -sf localhost;do sleep 1; done
wait_for_healthy_container ${container}

curl -fisk -H "Authorization: Bearer ${token}" -H "Host: watchtower.localhost" localhost/v1/update
curl -fisk -H "Host: api.localhost" localhost

#clean:
docker-compose down --remove-orphans -v --rmi local
