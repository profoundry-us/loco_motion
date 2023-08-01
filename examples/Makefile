##############################
# General commands
##############################

# Open a shell to your development container
.PHONY: dev-shell
dev-shell:
	docker exec -it $$(docker ps -q -f name=dev) /bin/bash

# Run & build all containers
.PHONY: dev
dev:
	docker compose up --build

# Run all containers without rebuilding
.PHONY: dev-quick
dev-quick:
	docker compose up

# Stop all running containers
.PHONY: down
down:
	docker compose down


##############################
# Rails app commands
##############################

# Open a bash shell in the running app container
.PHONY: app-shell
app-shell:
	docker exec -it $$(docker ps -q -f name=app) /bin/bash

# Open a Rails console
.PHONY: app-console
app-console:
	docker exec -it $$(docker ps -q -f name=app) rails c

# Run all Rspec tests
.PHONY: app-rspec
app-rspec:
	docker exec -it $$(docker ps -q -f name=app) rspec spec


##############################
# Database commands
##############################


# Open a bash shell in the running db container
.PHONY: db-shell
db-shell:
	docker exec -it $$(docker ps -q -f name=db) /bin/bash

# Open a connection to the development database
.PHONY: db-dev
db-dev:
	docker exec -it $$(docker ps -q -f name=db) psql -U postgres -d app_development

# Open a connection to the test database
.PHONY: db-test
db-test:
	docker exec -it $$(docker ps -q -f name=db) psql -U postgres -d app_test
