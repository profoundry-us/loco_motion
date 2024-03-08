##############################
# General commands
##############################

# Run and build all of the containers
.PHONY: all
all:
	docker compose up --build

# Run all of the containers without rebuilding
.PHONY: all-quick
all-quick:
	docker compose up

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
# App commands
##############################

# Run & build the app container
.PHONY: app
app:
	docker compose up app --build

# Run the app container without rebuilding
.PHONY: app-quick
app-quick:
	docker compose up app

# Open a Ruby console in the app container
.PHONY: app-console
app-console:
	docker compose exec -it app /home/loco_motion/bin/console.sh

# Open a shell to your app container
.PHONY: app-shell
app-shell:
	docker compose exec -it app /bin/bash

# Run all of the Rspec tests
.PHONY: app-test
app-test:
	docker compose exec -it app bundle exec rspec spec

##############################
# Yard commands
##############################

# Build and run the Yard container
.PHONY: yard
yard:
	docker compose up yard --build

# Run the yard container without building
.PHONY: yard-quick
yard-quick:
	docker compose up yard

# Open a bash shell in the running yard container
.PHONY: yard-shell
yard-shell:
	docker compose exec -it yard /bin/bash
