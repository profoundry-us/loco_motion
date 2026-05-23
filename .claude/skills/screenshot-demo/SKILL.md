---
name: screenshot-demo
description: Starts the LocoMotion demo Rails app locally (without Docker) and
  takes a full-page screenshot or video of a component example page. Use when
  the user says "screenshot", "take a screenshot", "show me what it looks
  like", "run the app", or "capture the page".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Screenshot Demo

Boots the LocoMotion demo Rails app using local Ruby (no Docker required) and
captures a screenshot of a component example page using Playwright.

## Environment Notes

- **Ruby**: The demo requires the exact Ruby version in `docs/demo/Gemfile`
  (currently `3.4.4`). Install it via rbenv if missing.
- **Node**: The demo's `package.json` `engines` field requires Node `~20`.
  Use `/opt/node20/bin` — not Node 21 or 22 which are also installed.
- **yarn**: Use the `yarn` binary from Node 22 (`/opt/node22/bin/yarn`)
  but with `PATH` pointing at Node 20 so esbuild picks up the right runtime.
- **Playwright browsers**: Installed to `/opt/pw-browsers`. Always set
  `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers` when running Playwright.

## Instructions

All commands run from `docs/demo/` unless stated otherwise.

### Step 1: Install the correct Ruby (one-time)

Check what the Gemfile specifies:

```bash
head -3 docs/demo/Gemfile | grep ruby
```

Install it if missing:

```bash
rbenv install <version>   # e.g. rbenv install 3.4.4
```

Verify:

```bash
RBENV_VERSION=<version> rbenv exec ruby --version
```

### Step 2: Set up the vendor symlink (one-time)

Docker normally mounts the root repo into `docs/demo/vendor/loco_motion-rails`.
For local dev, create the symlink manually:

```bash
mkdir -p docs/demo/vendor
ln -s /home/user/loco_motion docs/demo/vendor/loco_motion-rails
```

Then make sure the symlink is gitignored (add once, commit):

```bash
grep -q "vendor/loco_motion-rails" docs/demo/.gitignore || \
  echo "vendor/loco_motion-rails" >> docs/demo/.gitignore
```

If you added it to `.gitignore`, commit that change before continuing.

### Step 3: Install Ruby gems

```bash
RBENV_VERSION=<version> rbenv exec bundle install
```

Confirm Rails is available:

```bash
RBENV_VERSION=<version> rbenv exec bundle exec rails --version
```

### Step 4: Prepare the database

```bash
RBENV_VERSION=<version> rbenv exec bundle exec rails db:prepare
```

### Step 5: Install JS dependencies

The published npm package `@profoundry-us/loco_motion` won't resolve its own
`@hotwired/stimulus` dependency when linked. To use the **local source**
without permanently changing `yarn.lock`, patch `package.json` temporarily
and install with `--no-lockfile`:

```bash
# Point to local source (temporary)
sed -i 's|"@profoundry-us/loco_motion": ".*"|"@profoundry-us/loco_motion": "file:../.."|' \
  docs/demo/package.json

# Install without touching yarn.lock
PATH="/opt/node20/bin:$PATH" /opt/node22/bin/yarn install \
  --ignore-engines --no-lockfile

# Revert package.json immediately (yarn.lock is untouched)
git checkout -- docs/demo/package.json
```

`--no-lockfile` tells yarn to neither read nor write `yarn.lock`, so only
`package.json` was ever modified — and we've already reverted it. The
`node_modules` directory is not tracked by git, so nothing else needs
cleaning up.

### Step 6: Build JavaScript

```bash
PATH="/opt/node20/bin:$PATH" /opt/node22/bin/yarn build
```

Expected output: two `.js` files written to `app/assets/builds/`.

### Step 7: Build CSS

The Tailwind config calls `bundle show loco_motion-rails`, so Ruby must be in
scope:

```bash
RBENV_VERSION=<version> rbenv exec bundle exec \
  node docs/demo/node_modules/.bin/tailwindcss \
  -i ./app/assets/stylesheets/application.tailwind.css \
  -o ./app/assets/builds/application.css
```

Expected output ends with `Done in Xms`.

### Step 8: Start the Rails server

Remove any stale PID file, then start in the background:

```bash
rm -f docs/demo/tmp/pids/server.pid

RBENV_VERSION=<version> rbenv exec bundle exec rails server \
  -p 3000 -b 127.0.0.1 > /tmp/rails-demo.log 2>&1 &

echo $! > /tmp/rails-demo.pid
```

Wait for the server to accept connections (retry up to ~10 s):

```bash
for i in $(seq 1 10); do
  curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/ | grep -q "200" && break
  sleep 1
done
echo "Server ready"
```

If it never returns 200, check `/tmp/rails-demo.log` for startup errors.

### Step 9: Install Playwright browser (one-time)

```bash
PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers \
  PATH="/opt/node20/bin:$PATH" \
  /opt/node22/bin/yarn playwright install chromium
```

### Step 10: Take the screenshot

Write a small ESM script and run it with Node 20:

```bash
cat > /tmp/demo-screenshot.mjs << 'EOF'
import { chromium } from '/home/user/loco_motion/docs/demo/node_modules/@playwright/test/index.mjs';

const browser = await chromium.launch();
const page    = await browser.newPage();
await page.setViewportSize({ width: 1280, height: 900 });

// URL format: /examples/<FullRubyClassName>
// e.g. /examples/Daisy::Layout::HoverGalleryComponent
await page.goto('http://127.0.0.1:3000/examples/Daisy::Layout::HoverGalleryComponent');
await page.waitForLoadState('networkidle');

await page.screenshot({ path: '/tmp/demo-screenshot.png', fullPage: true });
await browser.close();
console.log('Screenshot saved to /tmp/demo-screenshot.png');
EOF

PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers \
  PATH="/opt/node20/bin:$PATH" \
  /opt/node20/bin/node /tmp/demo-screenshot.mjs
```

Send the file to the user:

```
SendUserFile: /tmp/demo-screenshot.png
```

### Step 11: Stop the server

```bash
kill $(cat /tmp/rails-demo.pid) 2>/dev/null
rm -f /tmp/rails-demo.pid docs/demo/tmp/pids/server.pid
```

## URL Format

Example pages use the full Ruby class name as the route parameter:

| Component | URL |
|-----------|-----|
| `Daisy::Layout::HoverGalleryComponent` | `/examples/Daisy::Layout::HoverGalleryComponent` |
| `Daisy::DataDisplay::CardComponent` | `/examples/Daisy::DataDisplay::CardComponent` |
| `Daisy::Actions::ButtonComponent` | `/examples/Daisy::Actions::ButtonComponent` |

Do **not** use the snake_case example name (e.g. `/examples/hover_galleries`)
— that path is only used internally by the helper and will 500.

## Key Pitfalls

| Pitfall | Fix |
|---------|-----|
| Wrong Ruby version | Always prefix commands with `RBENV_VERSION=<ver> rbenv exec` |
| Node 22 used for build | Set `PATH="/opt/node20/bin:$PATH"` before any yarn/node build command |
| `@hotwired/stimulus` unresolved | Use the `file:../..` + `--no-lockfile` pattern in Step 5; do NOT use `npm link` |
| `yarn.lock` gets modified | Only happens if you omit `--no-lockfile`; revert with `git checkout -- docs/demo/yarn.lock` |
| Stale server PID | `rm -f docs/demo/tmp/pids/server.pid` before starting |
| Playwright can't find browser | Set `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers` |
| Import `@playwright/test` fails | Import from the full path: `.../node_modules/@playwright/test/index.mjs` |

## Examples

**Example 1 — screenshot a single component**

User: "Show me what the Hover Gallery looks like"

- Target URL: `/examples/Daisy::Layout::HoverGalleryComponent`
- Output: `/tmp/demo-screenshot.png` sent to user

**Example 2 — screenshot after a code change**

After editing a component, run Steps 6–10 only (assets + screenshot). Steps
1–5 are one-time setup and only need to be repeated if gems or JS packages
change.

**Example 3 — video capture**

Replace the `page.screenshot` call with Playwright's video API:

```javascript
const context = await browser.newContext({
  recordVideo: { dir: '/tmp/', size: { width: 1280, height: 900 } }
});
const page = await context.newPage();
await page.goto('http://127.0.0.1:3000/examples/Daisy::Layout::HoverGalleryComponent');
await page.waitForLoadState('networkidle');
// interact with the page here if needed
await context.close(); // video is saved on context close
```

The video file appears in `/tmp/` with a random name; find it with
`ls -t /tmp/*.webm | head -1`.

## Troubleshooting

**Server exits immediately** — Check `/tmp/rails-demo.log`. Common causes:
missing database (`db:prepare`), missing `SECRET_KEY_BASE` (not needed in
development), or port 3000 already in use (`lsof -i :3000`).

**CSS missing / unstyled page** — Re-run Step 7. The `bundle show` call in
`tailwind.config.js` requires the correct Ruby version in `PATH`.

**JS build fails with "No matching export"** — The local loco_motion JS
source wasn't picked up. Re-run Step 5 carefully, ensuring the `sed` and
`yarn install --no-lockfile` both succeed before reverting `package.json`.

**Screenshot is blank or shows error page** — Confirm the server returned
200 (Step 8 health check) and the URL uses the full class name format
(Step 10 URL table).
