.PHONY: build push publish start restart stop clean ps logs put-test get-test

-include .env

CURRENT_ID := $(shell id -u)
CURRENT_GROUP := $(shell id -g)
CURRENT_DIR := $(shell pwd)
JQ := $(shell command -v jq 2> /dev/null)

D := CURRENT_USER=${CURRENT_ID}:${CURRENT_GROUP} docker
DC := CURRENT_USER=${CURRENT_ID}:${CURRENT_GROUP} docker compose -p $(PROJECT_NAME)


build:
	@$(D) build -f app/Dockerfile -t $(APP_IMAGE_NAME):$(APP_IMAGE_TAG) -t $(APP_IMAGE_NAME):latest app/

push:
	@$(D) push $(APP_IMAGE_NAME):$(APP_IMAGE_TAG)
	@$(D) push $(APP_IMAGE_NAME):latest

publish: build push

start:
	@$(DC) up -d

restart:
	@$(DC) restart

stop:
	@$(DC) down

clean:
	@$(DC) down --volumes --remove-orphans
	@$(D) rmi $(APP_IMAGE_NAME):$(APP_IMAGE_TAG)

ps:
	@$(DC) ps

logs:
	@$(DC) logs -f

put-test:
	@curl -k -X POST -H "Content-Type: application/json" -d '{"name": "John", "email": "john@example.com"}' https://localhost:8443/users

get-test:
# ifndef JQ
#     $(error "JQ is not installed. Please install jq tool from you package manager")
# endif
	@curl -s -k https://localhost:8443/users | jq
