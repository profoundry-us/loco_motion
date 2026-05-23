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

### Step 1: Run the setup hook (cloud sessions only)

In cloud sessions the `SessionStart` hook
(`.claude/hooks/setup-demo.sh`) runs automatically on every session start.
It handles Ruby installation, the vendor symlink, `bundle install`,
`db:prepare`, and JS dependency installation. Check whether it already ran:

```bash
# Hook success leaves this message in the session startup log:
# ==> [setup-demo] Setup complete. Start the demo server with the run-demo skill.
```

If the hook has not run yet (or failed), run it manually:

```bash
bash .claude/hooks/setup-demo.sh
```

If you are **not** in a cloud session (i.e. running locally), perform Steps
1–5 from the manual instructions in `SKILL.md` history, or consult the
hook script itself — it documents every step inline.

### Step 2: Build JavaScript

```bash
PATH="/opt/node20/bin:$PATH" /opt/node22/bin/yarn --cwd docs/demo build
```

Expected: two `.js` bundles written to `docs/demo/app/assets/builds/`.

### Step 3: Build CSS

The Tailwind config calls `bundle show loco_motion-rails`, so the correct
Ruby version must be in scope:

```bash
RBENV_VERSION=3.4.4 rbenv exec bundle exec \
  node docs/demo/node_modules/.bin/tailwindcss \
  -i ./app/assets/stylesheets/application.tailwind.css \
  -o ./app/assets/builds/application.css
```

Run this command from inside `docs/demo/`:

```bash
cd docs/demo && \
  RBENV_VERSION=3.4.4 rbenv exec bundle exec \
  node node_modules/.bin/tailwindcss \
  -i ./app/assets/stylesheets/application.tailwind.css \
  -o ./app/assets/builds/application.css
```

Expected: output ends with `Done in Xms`.

### Step 4: Start the Rails server

Remove any stale PID file, then launch in the background:

```bash
rm -f docs/demo/tmp/pids/server.pid

cd docs/demo && RBENV_VERSION=3.4.4 rbenv exec bundle exec rails server \
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

### Step 5: Stop the server (when done)

```bash
kill $(cat /tmp/rails-demo.pid) 2>/dev/null
rm -f /tmp/rails-demo.pid docs/demo/tmp/pids/server.pid
```

## Troubleshooting

**Server exits immediately** — Check `/tmp/rails-demo.log`. Common causes:
stale PID from a previous run (`rm -f docs/demo/tmp/pids/server.pid`), or
port 3000 already in use (`lsof -i :3000`).

**CSS is unstyled** — Re-run Step 3. `tailwind.config.js` calls
`bundle show loco_motion-rails`; if Ruby is not in scope that call fails
silently and outputs an empty stylesheet.

**JS build fails with "No matching export"** — The local loco_motion JS
source was not picked up. Re-run the hook (`bash .claude/hooks/setup-demo.sh`)
or repeat Step 5 of the hook manually and confirm the `sed` substitution
succeeded before running `yarn install`.

**`yarn.lock` shows as modified** — You ran `yarn install` without
`--no-lockfile`. Revert with `git checkout -- docs/demo/yarn.lock`.
