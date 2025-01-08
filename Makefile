MAKEFLAGS += --silent
SHELL := /bin/bash

.PHONY: all clean

all: clean
	./tests/test.sh

clean:
	docker-compose down --remove-orphans -v --rmi local
