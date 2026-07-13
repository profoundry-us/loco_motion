---
name: run-demo
description: Boots the LocoMotion demo Rails app, serving it on port 3000.
  Uses Docker locally (via `just demo`) and a no-Docker rbenv/node fallback
  for cloud sessions. Use when the user says "run the app", "start the demo",
  "boot the server", or as a prerequisite before taking screenshots or videos.
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Run Demo

Boots the LocoMotion demo Rails app, serving it on `http://127.0.0.1:3000`.
This is a prerequisite for the `screenshot-demo` skill.

Two execution paths exist depending on environment:

- **Local development (default)** — use Docker via the `justfile`. Docker
  is installed locally; this matches the canonical dev workflow.
- **Cloud sessions** — Docker is installed but not started by default. You
  have two options: run `bin/setup-docker` once to bootstrap the full
  Docker-based `just` workflow (then Path A works exactly as it does
  locally), or use the lighter no-Docker rbenv + Node fallback below (Path B)
  to just serve the demo; that fallback's setup is handled by the
  `SessionStart` hook.

Detect which environment you are in via `CLAUDE_CODE_REMOTE`: if set to
`true`, you are in a cloud session; otherwise you are local.

---

## Path A — Local (Docker, preferred)

All commands run from the repo root. Always use `just`, never raw
`docker compose`.

### Boot the demo container

```bash
just demo          # build + run the demo container (foreground)
just demo-quick    # run without rebuilding
```

The first run builds the image (slow); subsequent runs reuse it. The demo
is served at `http://127.0.0.1:3000` once Rails reports `Listening on`.

### Restart after library changes

Only required when files inside `lib/loco_motion/` change. Component or
demo edits are picked up automatically.

```bash
just demo-restart
```

### Stop the demo

```bash
just down          # stop all containers
```

### Other useful targets

```bash
just demo-shell      # open a bash shell inside the demo container
just demo-console    # open a Rails console
just demo-test       # run the demo RSpec suite
```

If `just demo` fails, check Docker is running (`docker ps`) and that no
other process is holding port 3000 (`lsof -i :3000`).

---

## Path B — Cloud Sessions (no Docker)

This path runs the demo directly against the host's Ruby and Node — no
Docker — which is the quickest way to just serve the demo in a cloud session.
(To instead use the full Docker-based `just` workflow there, run
`bin/setup-docker` once and follow Path A; see `CLAUDE.md`.) The
`SessionStart` hook (`.claude/hooks/setup-demo.sh`) handles all heavy setup
automatically on every session start: rbenv install, vendor symlink,
`bundle install`, `db:prepare`, and JS dependency installation.

### Environment Notes (cloud only)

- **Ruby**: required version from `docs/demo/Gemfile` (currently `3.4.4`),
  installed via rbenv.
- **Node**: the demo's `package.json` `engines` accepts Node 20 or 22
  (`~20 || ~22`); the Docker images and CI run 22, so use
  `/opt/node22/bin`.
- **yarn**: use `/opt/node22/bin/yarn` with `PATH="/opt/node22/bin:$PATH"`
  so esbuild and Tailwind pick up the same Node runtime.

### Step 1: Verify the setup hook ran

Check the session startup log for:

```
==> [setup-demo] Setup complete. Start the demo server with the run-demo skill.
```

If the hook did not run (or failed), trigger it manually:

```bash
bash .claude/hooks/setup-demo.sh
```

### Step 2: Build JavaScript

```bash
cd docs/demo && PATH="/opt/node22/bin:$PATH" /opt/node22/bin/yarn build
```

Expected: two `.js` bundles written to `docs/demo/app/assets/builds/`.

### Step 3: Build CSS

The Tailwind config calls `bundle show loco_motion-rails`, so Ruby must be
in scope:

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

---

## Troubleshooting

**Local: `just demo` exits immediately** — Run `docker compose logs demo`.
Common causes: image build failed, port 3000 held by another process
(`lsof -i :3000`), or stale containers (`just down` then retry).

**Cloud: Server exits immediately** — Check `/tmp/rails-demo.log`. Common
causes: stale PID from a previous run
(`rm -f docs/demo/tmp/pids/server.pid`), or port 3000 already in use
(`lsof -i :3000`).

**Cloud: CSS is unstyled** — Re-run Step 3. `tailwind.config.js` calls
`bundle show loco_motion-rails`; if Ruby is not in scope that call fails
silently and outputs an empty stylesheet.

**Cloud: JS build fails with "No matching export"** — The local
loco_motion JS source was not picked up. Re-run the hook
(`bash .claude/hooks/setup-demo.sh`) and confirm the `sed` substitution
on `package.json` succeeded before `yarn install` ran.

**Cloud: `yarn.lock` shows as modified** — You ran `yarn install` without
`--no-lockfile`. Revert with `git checkout -- docs/demo/yarn.lock`.
