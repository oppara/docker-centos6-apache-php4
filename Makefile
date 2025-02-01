SHELL := /bin/bash
IMAGE := oppara/centos6-apache-php4
PORT := 8080

all: help

.PHONY: build
build: ## build docker image
	docker build --no-cache --platform linux/amd64 ./docker -t $(IMAGE)

.PHONY: push
push: ## push docker image
	docker push $(IMAGE)

.PHONY: bash
bash: ## bash
	docker run --platform linux/amd64 --rm -it --name php4 $(IMAGE) bash

.PHONY: up
up: ## docker compose up
	docker compose up -d

.PHONY: down
down: ## docker compose down
	docker compose down
.PHONY: open
open: ## open browser
	open http://127.0.0.1:$(PORT)

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
