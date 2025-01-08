MAKEFLAGS += --silent
SHELL := /bin/bash

.PHONY: all sut clean

all: clean
	./tests/test.sh

sut:
	export COMPOSE_FILE=compose.yml:compose.sut.yml
	DOCKER_BUILDKIT=1 docker compose up --quiet-pull --no-color --remove-orphans --exit-code-from api

clean:
	docker-compose down --remove-orphans -v --rmi local
