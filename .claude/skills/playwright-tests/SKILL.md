---
name: playwright-tests
description: Writes and runs Playwright end-to-end tests for LocoMotion demo
  pages inside the Docker demo container. Use when the user says "write
  playwright tests", "add e2e tests", "run playwright", "write e2e tests", or
  "test with playwright".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Playwright Tests

Writes and/or runs Playwright end-to-end tests for LocoMotion demo pages.

## Instructions

### Step 1: Locate the example view

Find the HAML example file that the test will cover:

```
docs/demo/app/views/examples/daisy/{group}/{plural_name}.html.haml
```

Read it fully — tests must exercise what the view actually renders.

### Step 2: Find or create the spec file

Test files live at:

```
docs/demo/e2e/daisy/{group}/{plural_name}.spec.ts
```

Mirror the directory structure of the example views exactly. If the spec file
does not exist, create it.

### Step 3: Write the tests

Follow the structure of existing spec files (read one for reference). Each
`doc_example` block in the HAML should have at least one corresponding test.

```typescript
import { test, expect } from "@playwright/test";

test.describe("Badges", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/examples/daisy/data_display/badges");
  });

  test("renders basic badge", async ({ page }) => {
    await expect(page.locator(".badge").first()).toBeVisible();
  });

  test("renders badge with icon", async ({ page }) => {
    await expect(page.locator(".badge .icon")).toBeVisible();
  });
});
```

Rules:

- Use `page.goto` with the demo route matching the example file path.
- Test the golden path for each example.
- Use `locator` with DaisyUI CSS class selectors.
- Keep tests focused; one assertion per `test` block is ideal.

### Step 4: Run the tests

Always run inside the `demo` Docker container using Yarn:

```bash
docker compose exec -it demo yarn playwright test 'e2e/daisy/{group}/{plural_name}.spec.ts' --reporter dot --workers 1
```

Required flags (never omit):

| Flag | Reason |
|------|--------|
| `--reporter dot` | Compact output readable in terminal |
| `--workers 1` | Ensures CI stability |

To run an entire directory:

```bash
docker compose exec -it demo yarn playwright test 'e2e/daisy/data_display/' --reporter dot --workers 1
```

### Step 5: Interpret results

- `.` — test passed
- `F` — test failed (copy the error for diagnosis)
- `P` — test pending/skipped

All dots must be green before reporting success. Fix failures before
proceeding.

## Examples

**Example 1 — running a single spec**

```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/actions/buttons.spec.ts' \
  --reporter dot --workers 1
```

**Example 2 — running all data_display tests**

```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/data_display/' \
  --reporter dot --workers 1
```

**Example 3 — minimal spec file structure**

```typescript
import { test, expect } from "@playwright/test";

test.describe("Countdown", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/examples/daisy/actions/countdowns");
  });

  test("renders countdown", async ({ page }) => {
    await expect(page.locator(".countdown").first()).toBeVisible();
  });
});
```

## Troubleshooting

**`yarn` not found in container** — Confirm you are running inside the `demo`
container: `docker compose exec -it demo` prefix is required.

**404 on page.goto** — Verify the route matches the example file path. The
demo app must be running: `docker compose ps demo`.

**Tests pass locally but fail in CI** — Always use `--workers 1` to prevent
race conditions. Never increase the worker count.

**Locator finds 0 elements** — Read the rendered HAML to confirm the CSS class
exists. Use the browser's DevTools to inspect the actual DOM structure.
