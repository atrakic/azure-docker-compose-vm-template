all: clean
	docker compose up -d --remove-orphans
	docker exec nginx-proxy nginx -T
	curl -o /dev/null -H "Host: whoami.example" localhost
	while ! curl -o /dev/null -sf localhost;do sleep 1; done
	curl -I localhost
	curl localhost
	curl -H "Authorization: Bearer foo" -H "Host: watchtower" localhost/v1/update

clean:
	docker-compose down --remove-orphans -v --rmi local
