---
description: >
  Write and/or run Playwright end-to-end tests for a LocoMotion component
  example page. Use when asked to "write playwright tests", "add e2e tests",
  "test the X component", or "run the playwright tests for Y".
---

# Playwright Tests

Write or run Playwright tests: `$ARGUMENTS`

`$ARGUMENTS` can be:
- A component name: `buttons`, `checkboxes`, `modals`
- A file path: `e2e/daisy/actions/buttons.spec.ts`
- A directory: `e2e/daisy/data_input/`
- `all` to run the full test suite

## Writing New Tests

### Step 1 — Read the Example View

Find and read the HAML example file for the component:
```bash
find docs/demo/app/views/examples -name "{component}.html.haml"
```

This is the **source of truth** for what headings and content exist on
the page. Every `doc_example(title: "...")` becomes a section heading
in the test expectations.

### Step 2 — Check Existing Tests

Look for an existing spec to use as a reference:
```bash
ls docs/demo/e2e/daisy/{group}/
```

Read a similar spec (e.g., `checkboxes.spec.ts`) to match style:
```bash
cat docs/demo/e2e/daisy/data_input/checkboxes.spec.ts
```

### Step 3 — Create the Spec File

**Path**: `docs/demo/e2e/daisy/{group}/{component}.spec.ts`

The directory structure mirrors the example view structure.

**Template**:
```typescript
import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  // Click the nav link
  await loco.clickNavLink(page, '{ComponentTitle}');

  // Verify page title
  await loco.expectPageTitle(page, /{ComponentTitle} | LocoMotion/);

  // Verify all example section headings
  await loco.expectPageHeadings(page, [
    '{Example Title 1}',
    '{Example Title 2}',
    // ...
  ]);
});
```

Rules:
- Import `loco` from the relative path to `spec_helpers.ts`
- The nav link title must exactly match what appears in the sidebar
- Headings must exactly match the `title:` values in `doc_example` calls
- One `test` block per page (the standard pattern)
- Add additional `test` blocks for interactive behaviors if needed

### Step 4 — Verify Helper Paths

The import path for `spec_helpers` depends on nesting depth:
- `e2e/daisy/actions/*.spec.ts` → `import { loco } from '../../spec_helpers'`
- `e2e/daisy/data_input/*.spec.ts` → `import { loco } from '../../spec_helpers'`
- `e2e/pages/*.spec.ts` → `import { loco } from '../spec_helpers'`

Check `docs/demo/e2e/spec_helpers.ts` for available helper methods:
- `loco.clickNavLink(page, title)` — clicks a nav link by text
- `loco.expectPageTitle(page, /pattern/)` — asserts page `<title>`
- `loco.expectPageHeadings(page, ['H1', 'H2'])` — asserts visible headings

## Running Tests

### Run a Single Spec File

```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/actions/buttons.spec.ts' --reporter dot --workers 1
```

### Run a Directory

```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/data_input/' --reporter dot --workers 1
```

### Run All Tests

```bash
just playwright
```

(This uses `--workers 5` and trace-on by default from the justfile.)

## Interpreting Results

The `--reporter dot` output:
- `.` = passed
- `F` = failed
- `E` = error

If tests fail, read the error output to determine:
1. Is the nav link name wrong? (check the sidebar in the demo app)
2. Is a heading text different? (re-read the HAML example file)
3. Is the demo app running? (check `just status`)

## Resources

- Spec helpers: `docs/demo/e2e/spec_helpers.ts`
- E2e test directory: `docs/demo/e2e/`
- Example views: `docs/demo/app/views/examples/`
- Playwright config: `docs/demo/playwright.config.ts`
- Writing tests rules: `.windsurf/rules/writing_playwright_tests.md`
- Running tests rules: `.windsurf/rules/running_playwright_tests.md`
- Playwright docs: https://playwright.dev/docs/test-assertions
