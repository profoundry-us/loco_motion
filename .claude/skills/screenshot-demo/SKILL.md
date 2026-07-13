---
name: screenshot-demo
description: Takes a full-page screenshot or video of a LocoMotion demo page
  using Playwright. Requires the demo server to already be running (see the
  run-demo skill). Use when the user says "screenshot", "take a screenshot",
  "show me what it looks like", "capture the page", or "record a video".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Screenshot Demo

Captures a full-page screenshot or video of a LocoMotion demo example page
using Playwright and the local Node 20 runtime.

**Prerequisite**: The demo server must be running on `http://127.0.0.1:3000`.
If it is not, run the `run-demo` skill first.

## URL Format

Example pages are routed by full Ruby class name, **not** the snake_case
example identifier:

| Component | URL |
|-----------|-----|
| `Daisy::Layout::HoverGalleryComponent` | `/examples/Daisy::Layout::HoverGalleryComponent` |
| `Daisy::DataDisplay::CardComponent` | `/examples/Daisy::DataDisplay::CardComponent` |
| `Daisy::Actions::ButtonComponent` | `/examples/Daisy::Actions::ButtonComponent` |

Do **not** use the snake_case example name (e.g. `/examples/hover_galleries`)
— that path is only used internally and returns a 500.

## Environment Notes

- **Node**: Use `/opt/node22/bin/node` to run the screenshot script.
- **Playwright browsers**: Chromium is installed to `/opt/pw-browsers`.
  Always set `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers`.
- **Import path**: Import `chromium` from the local `node_modules`, not a
  global install — global `@playwright/test` is not available.

## Instructions

### Step 1: Install Playwright browser (one-time)

```bash
PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers \
  PATH="/opt/node22/bin:$PATH" \
  /opt/node22/bin/yarn playwright install chromium
```

### Step 2: Confirm the server is responding

```bash
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/
```

Must return `200`. If not, run the `run-demo` skill first.

### Step 3: Take a screenshot

Write a small ESM script and run it with Node 20:

```bash
cat > /tmp/demo-screenshot.mjs << 'EOF'
import { chromium } from '/home/user/loco_motion/docs/demo/node_modules/@playwright/test/index.mjs';

const browser = await chromium.launch();
const page    = await browser.newPage();
await page.setViewportSize({ width: 1280, height: 900 });

await page.goto('http://127.0.0.1:3000/examples/Daisy::Layout::HoverGalleryComponent');
await page.waitForLoadState('networkidle');

await page.screenshot({ path: '/tmp/demo-screenshot.png', fullPage: true });
await browser.close();
console.log('Screenshot saved to /tmp/demo-screenshot.png');
EOF

PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers \
  PATH="/opt/node22/bin:$PATH" \
  /opt/node22/bin/node /tmp/demo-screenshot.mjs
```

Then send the file to the user using the `SendUserFile` tool.

### Step 4: Record a video (optional)

Replace the screenshot block with Playwright's `recordVideo` context:

```bash
cat > /tmp/demo-video.mjs << 'EOF'
import { chromium } from '/home/user/loco_motion/docs/demo/node_modules/@playwright/test/index.mjs';

const browser = await chromium.launch();
const context = await browser.newContext({
  recordVideo: { dir: '/tmp/', size: { width: 1280, height: 900 } }
});
const page = await context.newPage();
await page.setViewportSize({ width: 1280, height: 900 });

await page.goto('http://127.0.0.1:3000/examples/Daisy::Layout::HoverGalleryComponent');
await page.waitForLoadState('networkidle');

// Add any interactions here (hover, click, scroll, etc.)

await context.close(); // video is written on close
await browser.close();
EOF

PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers \
  PATH="/opt/node22/bin:$PATH" \
  /opt/node22/bin/node /tmp/demo-video.mjs

# Find the recorded file
VIDEO=$(ls -t /tmp/*.webm | head -1)
echo "Video saved to $VIDEO"
```

Send the video file to the user using the `SendUserFile` tool.

## Troubleshooting

**`Cannot find package '@playwright/test'`** — You are importing from a
global path that does not exist. Use the full local path:
`/home/user/loco_motion/docs/demo/node_modules/@playwright/test/index.mjs`.

**`Executable doesn't exist` / browser not found** — Run Step 1 to install
Chromium, and confirm `PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers` is set.

**Screenshot is blank or shows a routing error page** — The URL is wrong.
Use the full Ruby class name (e.g. `Daisy::Layout::HoverGalleryComponent`),
not the snake_case example name.

**Screenshot shows an unstyled page** — Assets were not built. Go back to
the `run-demo` skill and re-run the JS and CSS build steps (Steps 6–7).

**Server not responding** — Run `curl -s http://127.0.0.1:3000/` to
confirm. If it is down, use the `run-demo` skill to restart it.
