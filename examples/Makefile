##############################
# General commands
##############################

# Run & build the dev container
.PHONY: dev
dev:
	docker compose up dev --build

# Run the dev container without rebuilding
.PHONY: dev-quick
dev-quick:
	docker compose up dev

# Open a shell to your development container
.PHONY: dev-shell
dev-shell:
	docker compose exec -it dev /bin/bash

# Stop all running containers
.PHONY: down
down:
	docker compose down


##############################
# Rails app commands
##############################

# Run all of the containers and build
.PHONY: app
app:
	docker compose up --build app

# Run all of the containers without building
.PHONY: app-quick
app-quick:
	docker compose up app

# Open a bash shell in the running app container
.PHONY: app-shell
app-shell:
	docker compose exec -it app /bin/bash

# Open a Rails console
.PHONY: app-console
app-console:
	docker compose exec -it app rails c

# Open a remote debugging console
.PHONY: app-debug
app-debug:
	docker compose exec -it app bundle exec rdbg -a

# Restart the Rails application
.PHONY: app-restart
app-restart:
	touch tmp/restart.txt

# Run all Rspec tests
.PHONY: app-rspec
app-rspec:
	docker compose exec -it app rspec spec


##############################
# Database commands
##############################


# Open a bash shell in the running db container
.PHONY: db-shell
db-shell:
	docker compose exec -it db /bin/bash

# Open a connection to the development database
.PHONY: db-dev
db-dev:
	docker compose exec -it db psql -U postgres -d app_development

# Open a connection to the test database
.PHONY: db-test
db-test:
	docker compose exec -it db psql -U postgres -d app_test
