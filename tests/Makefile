MAKEFLAGS += --silent
SHELL := /bin/bash

.PHONY: all clean

SUT = nginx-sut

all: validate clean
	docker compose up --build --remove-orphans -d
	docker exec nginx-proxy nginx -T
	curl -s -o /dev/null -H "Host: api.example" localhost
	#while ! curl -o /dev/null -sf localhost;do sleep 1; done
	while ! \
		[[ "$$(docker inspect --format "{{json .State.Health }}" $(SUT) | jq -r ".Status")" == "healthy" ]];\
		do \
		echo "waiting for $(SUT) ..."; \
		sleep 1; \
	done
	curl -H "Host: dev.localhost" localhost
	curl -H "Authorization: Bearer foo" -H "Host: watchtower" localhost/v1/update
	curl -H "Host: api.example" localhost
	curl -H "Host: not-found" localhost/health

validate:
	docker compose version
	docker compose config --quiet

clean:
	docker-compose down --remove-orphans -v --rmi local
