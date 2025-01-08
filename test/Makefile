MAKEFLAGS += --silent
SHELL := /bin/bash

.PHONY: all clean

all: clean
	docker compose version
	docker compose up --quiet-pull --no-color --build --remove-orphans -d
	docker exec nginx-proxy nginx -T
	curl -s -o /dev/null -H "Host: api.example" localhost
	#while ! curl -o /dev/null -sf localhost;do sleep 1; done
	while ! \
		[[ "$$(docker inspect --format "{{json .State.Health }}" nginx | jq -r ".Status")" == "healthy" ]];\
		do \
		echo "waiting nginx ..."; \
		sleep 1; \
	done
	curl -I -H "Host: dev.localhost" localhost
	curl -H "Host: dev.localhost" localhost/health
	curl -H "Authorization: Bearer foo" -H "Host: watchtower" localhost/v1/update
	curl -H "Host: api.example" localhost/health


clean:
	docker-compose down --remove-orphans -v --rmi local
