---
name: run-demo
description: Boots the LocoMotion demo Rails app locally without Docker,
  building all assets and starting the server on port 3000. Use when the user
  says "run the app", "start the demo", "boot the server", or as a prerequisite
  before taking screenshots or videos.
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Run Demo

Boots the LocoMotion demo Rails app using local Ruby (no Docker required),
serving it on `http://127.0.0.1:3000`. This is a prerequisite for the
`screenshot-demo` skill.

## Environment Notes

- **Ruby**: The demo requires the exact version in `docs/demo/Gemfile`
  (currently `3.4.4`). Install it via rbenv if missing.
- **Node**: The demo's `package.json` `engines` field requires Node `~20`.
  Use `/opt/node20/bin` — not Node 21 or 22 which are also present.
- **yarn**: Use the `yarn` binary from `/opt/node22/bin/yarn` but always
  set `PATH="/opt/node20/bin:$PATH"` so esbuild and Tailwind pick up the
  correct Node runtime.

All commands run from `docs/demo/` unless stated otherwise.

## Instructions

### Step 1: Install the correct Ruby (one-time)

Check the required version:

```bash
head -3 docs/demo/Gemfile | grep ruby
```

Install via rbenv if it is not already present:

```bash
rbenv install <version>   # e.g. rbenv install 3.4.4
```

Verify:

```bash
RBENV_VERSION=<version> rbenv exec ruby --version
```

### Step 2: Set up the vendor symlink (one-time)

Docker mounts the root repo into `docs/demo/vendor/loco_motion-rails`.
Replicate that locally with a symlink:

```bash
mkdir -p docs/demo/vendor
ln -s /home/user/loco_motion docs/demo/vendor/loco_motion-rails
```

Make sure the symlink is gitignored. If the line is missing, add and commit
it:

```bash
grep -q "vendor/loco_motion-rails" docs/demo/.gitignore || \
  echo "vendor/loco_motion-rails" >> docs/demo/.gitignore
git add docs/demo/.gitignore && git commit -m 'chore(demo): Ignore vendor symlink used for local dev'
```

### Step 3: Install Ruby gems

```bash
RBENV_VERSION=<version> rbenv exec bundle install
```

Confirm Rails loaded correctly:

```bash
RBENV_VERSION=<version> rbenv exec bundle exec rails --version
```

### Step 4: Prepare the database

```bash
RBENV_VERSION=<version> rbenv exec bundle exec rails db:prepare
```

### Step 5: Install JS dependencies

The published npm package `@profoundry-us/loco_motion` cannot resolve its
own `@hotwired/stimulus` dependency when installed via `npm link`. Instead,
temporarily point `package.json` to the local source, install with
`--no-lockfile` (so `yarn.lock` is never touched), then immediately revert
`package.json`:

```bash
# Point to local source (temporary edit)
sed -i 's|"@profoundry-us/loco_motion": ".*"|"@profoundry-us/loco_motion": "file:../.."|' \
  docs/demo/package.json

# Install without reading or writing yarn.lock
PATH="/opt/node20/bin:$PATH" /opt/node22/bin/yarn install \
  --ignore-engines --no-lockfile

# Revert package.json — yarn.lock was never touched
git checkout -- docs/demo/package.json
```

The `node_modules/` directory is gitignored, so no further cleanup is needed.

> **Why not `npm link`?** When using `npm link` or `yarn link`, Node
> resolves the linked package's own imports (e.g. `@hotwired/stimulus`)
> relative to the *link source* directory, which has no `node_modules`.
> The `file:` + `--no-lockfile` pattern avoids this by installing the
> package in-place inside the demo's own `node_modules`.

### Step 6: Build JavaScript

```bash
PATH="/opt/node20/bin:$PATH" /opt/node22/bin/yarn build
```

Expected: two `.js` bundles written to `app/assets/builds/`.

### Step 7: Build CSS

The Tailwind config calls `bundle show loco_motion-rails`, so the correct
Ruby version must be in scope:

```bash
RBENV_VERSION=<version> rbenv exec bundle exec \
  node docs/demo/node_modules/.bin/tailwindcss \
  -i ./app/assets/stylesheets/application.tailwind.css \
  -o ./app/assets/builds/application.css
```

Expected: output ends with `Done in Xms`.

### Step 8: Start the Rails server

Remove any stale PID file, then launch in the background:

```bash
rm -f docs/demo/tmp/pids/server.pid

RBENV_VERSION=<version> rbenv exec bundle exec rails server \
  -p 3000 -b 127.0.0.1 > /tmp/rails-demo.log 2>&1 &

echo $! > /tmp/rails-demo.pid
```

Wait for the server to accept connections:

```bash
for i in $(seq 1 10); do
  curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/ \
    | grep -q "200" && echo "Server ready" && break
  sleep 1
done
```

If it never returns 200, check `/tmp/rails-demo.log` for errors.

### Step 9: Stop the server (when done)

```bash
kill $(cat /tmp/rails-demo.pid) 2>/dev/null
rm -f /tmp/rails-demo.pid docs/demo/tmp/pids/server.pid
```

## Skipping Steps on Repeat Runs

Steps 1–5 are **one-time setup**. On subsequent runs (e.g. after editing a
component), only Steps 6–8 are needed to rebuild assets and restart the
server.

## Troubleshooting

**Server exits immediately** — Check `/tmp/rails-demo.log`. Common causes:
stale PID from a previous run (`rm -f docs/demo/tmp/pids/server.pid`), or
port 3000 already in use (`lsof -i :3000`).

**CSS is unstyled** — Re-run Step 7. `tailwind.config.js` calls
`bundle show loco_motion-rails`; if Ruby is not in scope that call fails
silently and outputs an empty stylesheet.

**JS build fails with "No matching export"** — The local loco_motion JS
source was not picked up. Repeat Step 5 carefully and confirm the `sed`
substitution succeeded before running `yarn install`.

**`yarn.lock` shows as modified** — You ran `yarn install` without
`--no-lockfile`. Revert with `git checkout -- docs/demo/yarn.lock`.
