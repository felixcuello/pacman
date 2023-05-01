all: build up

build:
	docker compose build

rspec:
	docker compose run pacmapp bundle exec rspec

testshell:
	docker compose run pacmapp bash

test: rspec

up:
	docker compose up
