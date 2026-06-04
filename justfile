##############################
# General commands
##############################

# Show available just commands
default:
    just --list

# Prune ALL of the docker things (WARNING - this will destroy other project stuff too!!!)
prune:
    docker system prune --volumes -af

# Build everything but don't run the containers
build:
    docker compose build

# Rebuild everything without using the cache
rebuild:
    docker compose build --no-cache

# Run and build all of the containers
all:
    docker compose up --build

# Run all of the containers without rebuilding
all-fast:
    docker compose up

# Run all of the tests (uses running containers)
test:
    just loco-test && just demo-test && just playwright

# Run & build the dev container
dev:
    docker compose up dev --build

# Run the dev container without rebuilding
dev-fast:
    docker compose up dev

# Open a shell to your development container
dev-shell:
    docker compose exec -it dev /bin/bash

# Stop all running containers
down:
    docker compose down


##############################
# loco commands
##############################

# Run & build the loco container
loco:
    docker compose up loco --build

# Run the loco container without rebuilding
loco-fast:
    docker compose up loco

# Open a Ruby console in the loco container
loco-console:
    docker compose exec -it loco /home/loco_motion/bin/console

# Open a shell to your loco container
loco-shell:
    docker compose exec -it loco /bin/bash

# Run all of the Rspec tests
loco-test:
    docker compose exec -it loco bundle exec rspec spec

# Run RuboCop inside the loco container (config tuned to conventions; not a CI gate)
lint:
    docker compose exec -it loco bundle exec rubocop

# Run RuboCop with auto-fix inside the loco container
lint-fix:
    docker compose exec -it loco bundle exec rubocop -A


##############################
# demo commands
##############################

# Run & build the demo container
demo:
    docker compose up demo --build

# Run the demo container without rebuilding
demo-fast:
    docker compose up demo

# Open a Ruby console in the demo container
demo-console:
    docker compose exec -it demo rails console

# Restart the demo app
demo-restart:
    touch docs/demo/tmp/restart.txt
    terminal-notifier -message "Loco Demo App restarting..." || true

# Open a shell to your demo container
demo-shell:
    docker compose exec -it demo /bin/bash

# Open a bash shell to debug problems
demo-debug:
    docker compose run --rm demo /bin/bash

# Turns on caching for the demo container
demo-cache:
    touch docs/demo/tmp/caching-dev.txt

# Turns off caching for the demo container
demo-nocache:
    rm -f docs/demo/tmp/caching-dev.txt

# Run all of the Demo App Rspec tests
demo-test:
    docker compose exec -it demo bundle exec rspec spec


##############################
# Database commands
##############################

# Open a bash shell in the running db container
db-shell:
    docker compose exec -it db /bin/bash

# Open a connection to the development database
db-dev:
    docker compose exec -it db psql -U postgres -d trc_development

# Open a connection to the test database
db-test:
    docker compose exec -it db psql -U postgres -d trc_test


##############################
# Yard commands
##############################

# Build and run the Yard container
yard:
    docker compose up yard --build

# Cleanup all cached / generated yard files
yard-clean:
    rm -rf docs/yard/generated
    rm -rf .yardoc

# Run the yard container without building
yard-fast:
    docker compose up yard

# Open a bash shell in the running yard container
yard-shell:
    docker compose exec -it yard /bin/bash


##############################
# Algolia commands
##############################

# Run the algolia:index rake task in the demo container
algolia-index args="":
    docker compose exec -it demo bundle exec rake algolia:index ARGS="{{args}}"

# Run the algolia:clear rake task in the demo container
algolia-clear args="":
    docker compose exec -it demo bundle exec rake algolia:clear ARGS="{{args}}"

# Generate llms.txt documentation file
llm args="":
    docker compose exec -it demo bundle exec rake algolia:llm ARGS="{{args}}"


##############################
# Playwright / E2E commands
##############################

# Run the playwright tests in the demo container; the UI mode automatically runs from the Procfile.dev
playwright:
    docker compose exec -it demo yarn playwright test 'e2e' --reporter=dot --workers=5 --trace on


##############################
# Build/Publish commands
##############################

version := `grep -o '".*"' lib/loco_motion/version.rb | tr -d '"'`

# Print the current version
version:
    @echo {{version}}

# Verify the version sources agree (canonical source is lib/loco_motion/version.rb)
version-check:
    ./bin/version-check

# Helper target to create release checklist for a given version
create-checklist version:
    @echo "Creating release checklist..."
    @mkdir -p docs/checklists
    @cp docs/templates/release_checklist.md docs/checklists/release-checklist-v{{version}}.md
    @sed -i '' 's/Release Checklist Template/Release Checklist for v{{version}}/g' docs/checklists/release-checklist-v{{version}}.md
    @sed -i '' 's/x\.y\.z/{{version}}/g' docs/checklists/release-checklist-v{{version}}.md
    @sed -i '' 's/\[VERSION\]/{{version}}/g' docs/checklists/release-checklist-v{{version}}.md
    @sed -i '' 's/___________/{{version}}/g' docs/checklists/release-checklist-v{{version}}.md
    @echo "✓ Created release checklist: docs/checklists/release-checklist-v{{version}}.md"

# Bump the version using the update_version script
version-bump:
    docker compose exec -it loco bin/update_version
    just create-checklist {{version}}

# Bump the version to a specific version
version-set new_version:
    @if [ -z "{{new_version}}" ]; then \
        echo "Usage: just version-set NEW_VERSION=x.y.z"; \
    else \
        docker compose exec -it loco bin/update_version {{new_version}}; \
        just create-checklist {{new_version}}; \
    fi

# Update only the loco container to use the new gem version (safe to run anytime)
loco-version-lock:
    @echo "Updating loco container to use version {{version}}..."
    docker compose exec -it loco bundle
    @echo "✓ Loco container updated to version {{version}}"

# Update only the demo app to use the new versions (requires NPM package to be published)
demo-version-lock:
    @echo "Updating demo app to use version {{version}}..."
    @if npm view @profoundry-us/loco_motion@{{version}} version >/dev/null 2>&1; then \
        echo "✓ NPM package @profoundry-us/loco_motion@{{version}} found"; \
        docker compose exec -it demo bundle; \
        docker compose exec -it demo yarn; \
        echo "✓ Demo app updated to version {{version}}"; \
    else \
        echo "✗ NPM package @profoundry-us/loco_motion@{{version}} not found in registry"; \
        echo "  Please publish the NPM package first with: just npm-publish"; \
        exit 1; \
    fi

# Builds a new version of the gem in the builds/rubygems directory
gem-build:
    mkdir -p builds/rubygems
    docker compose exec -it loco gem build loco_motion-rails.gemspec -o builds/rubygems/loco_motion-rails-{{version}}.gem

# Publishes the RubyGem to RubyGems.org
gem-publish:
    docker compose exec -it loco gem push builds/rubygems/loco_motion-rails-{{version}}.gem

# Builds a new version of the NPM package in the builds/npm directory
npm-build:
    mkdir -p builds/npm
    npm pack --pack-destination builds/npm

# Publishes the NPM Package to NPM Registry
npm-publish:
    npm publish --access public


##############################
# Additional Justfile features
##############################

# Show Docker compose status
status:
    docker compose ps

# View logs for all services
logs:
    docker compose logs -f

# View logs for specific service
logs-service service:
    docker compose logs -f {{service}}

# Clean up Docker resources
clean:
    docker compose down --volumes --remove-orphans
    docker system prune -f
