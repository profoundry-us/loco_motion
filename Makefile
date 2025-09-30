##############################
# General commands
##############################

# Prune ALL of the docker things (WARNING - this will destroy other project
# stuff too!!!)
.PHONY: prune
prune:
	docker system prune --volumes -af

# Build everything but don't run the containers
.PHONY: build
build:
	docker compose build

# Rebuild everything without using the cache
.PHONY: rebuild
rebuild:
	docker compose build --no-cache

# Run and build all of the containers
.PHONY: all
all:
	docker compose up --build

# Run all of the containers without rebuilding
.PHONY: all-quick
all-quick:
	docker compose up

# Run all of the tests (uses running containers)
.PHONY: test
test:
	make loco-test && make demo-test && make playwright

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
	docker compose exec -it loco /home/loco_motion/bin/console

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
	docker compose exec -it demo rails console

# Restart the demo app
.PHONY: demo-restart
demo-restart:
	touch docs/demo/tmp/restart.txt
	terminal-notifier -message "Loco Demo App restarting..." || true

# Open a shell to your demo container
.PHONY: demo-shell
demo-shell:
	docker compose exec -it demo /bin/bash

# Open a bash shell to debug problems
.PHONY: demo-debug
demo-debug:
	docker compose run --rm demo /bin/bash

# Turns on caching for the demo container
.PHONY: demo-cache
demo-cache:
	touch docs/demo/tmp/caching-dev.txt

# Turns off caching for the demo container
.PHONY: demo-nocache
demo-nocache:
	rm -f docs/demo/tmp/caching-dev.txt

# Run all of the Demo App Rspec tests
.PHONY: demo-test
demo-test:
	docker compose exec -it demo bundle exec rspec spec

##############################
# Yard commands
##############################

# Build and run the Yard container
.PHONY: yard
yard:
	docker compose up yard --build

# Cleanup all cached / generated yard files
.PHONY: yard-clean
yard-clean:
	rm -rf docs/yard/generated
	rm -rf .yardoc

# Run the yard container without building
.PHONY: yard-quick
yard-quick:
	docker compose up yard

# Open a bash shell in the running yard container
.PHONY: yard-shell
yard-shell:
	docker compose exec -it yard /bin/bash

##############################
# Algolia commands
##############################

# Run the algolia:index rake task in the demo container
.PHONY: algolia-index
algolia-index:
	docker compose exec -it demo bundle exec rake algolia:index ARGS="$(ARGS)"

# Run the algolia:clear rake task in the demo container
.PHONY: algolia-clear
algolia-clear:
	docker compose exec -it demo bundle exec rake algolia:clear ARGS="$(ARGS)"

# Generate LLM.txt documentation file
.PHONY: llm
llm:
	docker compose exec -it demo bundle exec rake algolia:llm ARGS="$(ARGS)"

##############################
# Playwright / E2E commands
##############################

# Run the playwright tests in the demo container; the UI mode automatically runs from the Procfile.dev
.PHONY: playwright
playwright:
	docker compose exec -it demo yarn playwright test 'e2e' --reporter=dot,html --workers=5 --trace on

##############################
# Build/Publish commands
##############################

version=$(shell grep -o '".*"' lib/loco_motion/version.rb | tr -d '"')

# Print the current version
.PHONY: version
version:
	@echo $(version)

# Helper target to create release checklist for a given version
.PHONY: create-checklist
create-checklist:
	@echo "Creating release checklist..."
	@mkdir -p docs/checklists
	@cp docs/templates/release_checklist.md docs/checklists/release-checklist-v$(CHECKLIST_VERSION).md
	@sed -i '' 's/Release Checklist Template/Release Checklist for v$(CHECKLIST_VERSION)/g' docs/checklists/release-checklist-v$(CHECKLIST_VERSION).md
	@sed -i '' 's/x\.y\.z/$(CHECKLIST_VERSION)/g' docs/checklists/release-checklist-v$(CHECKLIST_VERSION).md
	@sed -i '' 's/\[VERSION\]/$(CHECKLIST_VERSION)/g' docs/checklists/release-checklist-v$(CHECKLIST_VERSION).md
	@sed -i '' 's/___________/$(CHECKLIST_VERSION)/g' docs/checklists/release-checklist-v$(CHECKLIST_VERSION).md
	@echo "✓ Created release checklist: docs/checklists/release-checklist-v$(CHECKLIST_VERSION).md"

# Bump the version using the update_version script
.PHONY: version-bump
version-bump:
	docker compose exec -it loco bin/update_version
	@$(MAKE) create-checklist CHECKLIST_VERSION=$(version)

# Bump the version to a specific version
.PHONY: version-set
version-set:
	@if [ -z "$(NEW_VERSION)" ]; then \
		echo "Usage: make version-set NEW_VERSION=x.y.z"; \
	else \
		docker compose exec -it loco bin/update_version $(NEW_VERSION); \
		$(MAKE) create-checklist CHECKLIST_VERSION=$(NEW_VERSION); \
	fi

# Update only the loco container to use the new gem version (safe to run anytime)
.PHONY: loco-version-lock
loco-version-lock:
	@echo "Updating loco container to use version $(version)..."
	docker compose exec -it loco bundle
	@echo "✓ Loco container updated to version $(version)"

# Update only the demo app to use the new versions (requires NPM package to be published)
.PHONY: demo-version-lock
demo-version-lock:
	@echo "Updating demo app to use version $(version)..."
	@if npm view @profoundry-us/loco_motion@$(version) version >/dev/null 2>&1; then \
		echo "✓ NPM package @profoundry-us/loco_motion@$(version) found"; \
		docker compose exec -it demo bundle; \
		docker compose exec -it demo yarn; \
		echo "✓ Demo app updated to version $(version)"; \
	else \
		echo "✗ NPM package @profoundry-us/loco_motion@$(version) not found in registry"; \
		echo "  Please publish the NPM package first with: make npm-publish"; \
		exit 1; \
	fi


# Builds a new version of the gem in the builds/rubygems directory
.PHONY: gem-build
gem-build:
	mkdir -p builds/rubygems
	docker compose exec -it loco gem build loco_motion-rails.gemspec -o builds/rubygems/loco_motion-rails-$(version).gem

# Publishes the RubyGem to RubyGems.org
.PHONY: gem-publish
gem-publish:
	docker compose exec -it loco gem push builds/rubygems/loco_motion-rails-$(version).gem

# Builds a new version of the NPM package in the builds/npm directory
.PHONY: npm-build
npm-build:
	mkdir -p builds/npm
	npm pack --pack-destination builds/npm

# Publishes the NPM Package to NPM Registry
.PHONY: npm-publish
npm-publish:
	npm publish --access public
