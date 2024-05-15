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
# loco commands
##############################

# Run & build the loco container
.PHONY: loco
loco:
	docker compose up loco --build

# Run the loco container without rebuilding
.PHONY: loco-quick
loco-quick:
	docker compose up loco

# Open a Ruby console in the loco container
.PHONY: loco-console
loco-console:
	docker compose exec -it loco /home/loco_motion/bin/console.sh

# Open a shell to your loco container
.PHONY: loco-shell
loco-shell:
	docker compose exec -it loco /bin/bash

# Run all of the Rspec tests
.PHONY: loco-test
loco-test:
	docker compose exec -it loco bundle exec rspec spec

##############################
# demo commands
##############################

# Run & build the demo container
.PHONY: demo
demo:
	docker compose up demo --build

# Run the demo container without rebuilding
.PHONY: demo-quick
demo-quick:
	docker compose up demo

# Open a Ruby console in the demo container
.PHONY: demo-console
demo-console:
	docker compose exec -it demo /home/loco_demo/bin/console.sh

# Restart the demo app
.PHONY: demo-restart
demo-restart:
	touch docs/demo/tmp/restart.txt

# Open a shell to your demo container
.PHONY: demo-shell
demo-shell:
	docker compose exec -it demo /bin/bash

# Run all of the Rspec tests
.PHONY: demo-test
demo-test:
	docker compose exec -it demo bundle exec rspec spec

# Open a bash shell to debug problems
.PHONY: demo-debug
demo-debug:
	docker compose run --rm demo /bin/bash

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
