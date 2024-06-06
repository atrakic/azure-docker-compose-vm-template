MAKEFLAGS += --silent

.PHONY: all clean

all: clean
	docker compose up --build --remove-orphans -d
	docker exec nginx-proxy nginx -T
	curl -s -o /dev/null -H "Host: whoami.example" localhost
	#while ! curl -o /dev/null -sf localhost;do sleep 1; done
	while ! \
		[[ "$$(docker inspect --format "{{json .State.Health }}" nginx | jq -r ".Status")" == "healthy" ]];\
		do \
		echo "waiting nginx ..."; \
		sleep 1; \
	done
	curl -I -H "Host: dev.localhost" localhost
	curl -H "Authorization: Bearer foo" -H "Host: watchtower" localhost/v1/update
	curl -H "Host: whoami.example" localhost

clean:
	docker-compose down --remove-orphans -v --rmi local
