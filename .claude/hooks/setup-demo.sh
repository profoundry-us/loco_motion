#!/bin/bash
#
# LocoMotion demo environment setup.
# Runs on every cloud session start to ensure the demo app's Ruby gems,
# JS packages, and compiled assets are ready to use.
#
# Only executes in remote (cloud) environments; exits immediately when run
# locally so it never interferes with Docker-based dev workflows.
#
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REPO_ROOT="${CLAUDE_PROJECT_DIR:-/home/user/loco_motion}"
DEMO_DIR="$REPO_ROOT/docs/demo"
RUBY_VERSION="3.4.4"
NODE22="/opt/node22/bin"
YARN="/opt/node22/bin/yarn"

log() { echo "==> [setup-demo] $*"; }

# ---------------------------------------------------------------------------
# 1. Ruby — install the required version if rbenv doesn't have it yet
# ---------------------------------------------------------------------------
log "Checking Ruby $RUBY_VERSION..."
rbenv install --skip-existing "$RUBY_VERSION"

# ---------------------------------------------------------------------------
# 2. Vendor symlink — mirrors the Docker Compose volume mount
# ---------------------------------------------------------------------------
log "Setting up vendor symlink..."
VENDOR_LINK="$DEMO_DIR/vendor/loco_motion-rails"
if [ ! -L "$VENDOR_LINK" ]; then
  mkdir -p "$DEMO_DIR/vendor"
  ln -s "$REPO_ROOT" "$VENDOR_LINK"
fi

# ---------------------------------------------------------------------------
# 3. Ruby gems
# ---------------------------------------------------------------------------
log "Installing Ruby gems..."
cd "$DEMO_DIR"
RBENV_VERSION="$RUBY_VERSION" rbenv exec bundle install

# ---------------------------------------------------------------------------
# 4. Database
# ---------------------------------------------------------------------------
log "Preparing database..."
RBENV_VERSION="$RUBY_VERSION" rbenv exec bundle exec rails db:prepare

# ---------------------------------------------------------------------------
# 5. JS dependencies
#
# The published @profoundry-us/loco_motion npm package cannot resolve its
# own @hotwired/stimulus dependency when installed via npm/yarn link.
# Temporarily point package.json at the local source (file:../..),
# install with --no-lockfile so yarn.lock is never touched, then restore
# package.json immediately. node_modules is gitignored so no cleanup needed.
# ---------------------------------------------------------------------------
log "Installing JS dependencies..."
sed -i \
  's|"@profoundry-us/loco_motion": ".*"|"@profoundry-us/loco_motion": "file:../.."|' \
  "$DEMO_DIR/package.json"

# Restore package.json on exit (success or failure)
trap 'git -C "$REPO_ROOT" checkout -- docs/demo/package.json 2>/dev/null || true' EXIT

PATH="$NODE22:$PATH" "$YARN" install --ignore-engines --no-lockfile
git -C "$REPO_ROOT" checkout -- docs/demo/package.json

# ---------------------------------------------------------------------------
# 6. JavaScript bundle
# ---------------------------------------------------------------------------
log "Building JavaScript..."
PATH="$NODE22:$PATH" "$YARN" build

# ---------------------------------------------------------------------------
# 7. CSS bundle
#
# tailwind.config.js calls `bundle show loco_motion-rails`, so Ruby must be
# in scope via RBENV_VERSION.
# ---------------------------------------------------------------------------
log "Building CSS..."
RBENV_VERSION="$RUBY_VERSION" rbenv exec bundle exec \
  node node_modules/.bin/tailwindcss \
  -i ./app/assets/stylesheets/application.tailwind.css \
  -o ./app/assets/builds/application.css

log "Setup complete. Start the demo server with the run-demo skill."
