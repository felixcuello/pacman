all: build testshell

build:
	docker compose build

testshell:
	docker compose run pacmapp bash
