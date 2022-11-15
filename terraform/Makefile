modules/lambda/is_sleeping/package.zip: modules/lambda/is_sleeping/app.rb modules/lambda/is_sleeping/Gemfile
	cd modules/lambda && docker compose up

dev-deploy:
	cd environments/development && terraform init && terraform apply

stg-deploy:
	cd environments/staging && terraform init && terraform apply

prd-deploy:
	cd environments/production && terraform init && terraform apply

.PHONY: help
help: ## Usage
	@grep -E '^[a-z0-9A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: dev
dev: modules/lambda/is_sleeping/package.zip dev-deploy

.PHONY: stg
stg: modules/lambda/is_sleeping/package.zip stg-deploy

.PHONY: prd
prd: modules/lambda/is_sleeping/package.zip prd-deploy

.PHONY: dev-destroy
dev-destroy:
	cd environments/development && terraform init && terraform destroy

.PHONY: stg-destroy
stg-destroy:
	cd environments/staging && terraform init && terraform destroy

.PHONY: prd-destroy
prd-destroy:
	cd environments/production && terraform init && terraform destroy

.DEFAULT_GOAL := dev
