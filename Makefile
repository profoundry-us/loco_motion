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
