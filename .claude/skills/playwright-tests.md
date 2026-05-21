---
description: >
  Write new Playwright end-to-end tests or run existing ones for a
  LocoMotion component example page. Use when asked to write playwright
  tests, add e2e tests, test a component page, or run the playwright
  suite for a specific component or directory.
---

# Playwright Tests

## When to Use

- "Write playwright tests for buttons"
- "Add e2e tests for the Alert component"
- "Run the playwright tests for data_input"
- "The playwright tests are failing for modals"

## Writing New Tests

### Step 1 — Read the Example View

The HAML example file is the source of truth for page content:

```bash
find docs/demo/app/views/examples -name "{component}.html.haml"
```

Every `doc_example(title: "...")` call becomes a visible `<h2>` heading.
Build the heading list from these titles.

### Step 2 — Find a Reference Spec

```bash
ls docs/demo/e2e/daisy/{group}/
cat docs/demo/e2e/daisy/data_input/checkboxes.spec.ts
```

### Step 3 — Create the Spec File

**Path**: `docs/demo/e2e/daisy/{group}/{component}.spec.ts`

The directory mirrors `docs/demo/app/views/examples/daisy/{group}/`.

**Standard template:**
```typescript
import { test } from '@playwright/test';
import { loco } from '../../spec_helpers';

test('page loads', async ({ page }) => {
  await page.goto('/');

  await loco.clickNavLink(page, '{Nav Link Title}');

  await loco.expectPageTitle(page, /{Page Title} | LocoMotion/);

  await loco.expectPageHeadings(page, [
    '{Example Title 1}',
    '{Example Title 2}',
    // one entry per doc_example title in the HAML file
  ]);
});
```

**Import path depth** (count folders from `e2e/`):
- `e2e/daisy/actions/` → `'../../spec_helpers'`
- `e2e/daisy/data_input/` → `'../../spec_helpers'`
- `e2e/pages/` → `'../spec_helpers'`

### Step 4 — Available Helpers

Read `docs/demo/e2e/spec_helpers.ts` for the full API:
- `loco.clickNavLink(page, title)` — clicks a sidebar nav link by text
- `loco.expectPageTitle(page, /pattern/)` — asserts the `<title>` tag
- `loco.expectPageHeadings(page, ['H1', 'H2'])` — asserts visible headings

## Running Tests

**One spec file:**
```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/actions/buttons.spec.ts' --reporter dot --workers 1
```

**A directory:**
```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/data_input/' --reporter dot --workers 1
```

**Full suite (uses justfile defaults):**
```bash
just playwright
```

Always use `--reporter dot` and `--workers 1` for any targeted run.

## Interpreting Failures

| Symptom                              | Likely cause                          |
|--------------------------------------|---------------------------------------|
| `clickNavLink` times out             | Nav link title doesn't match sidebar  |
| `expectPageHeadings` fails           | Heading text changed in the HAML      |
| Connection refused / 502             | Demo app not running (`just status`)  |
| Flaky pass/fail                      | Try `--workers 1` if not already set  |

When a heading test fails, re-read the HAML file — the titles must be
an **exact** character-for-character match of the `doc_example` titles.

## Resources

- Spec helpers: `docs/demo/e2e/spec_helpers.ts`
- E2e test directory: `docs/demo/e2e/`
- Example views: `docs/demo/app/views/examples/`
- Playwright config: `docs/demo/playwright.config.ts`
- Writing tests rules: `.windsurf/rules/writing_playwright_tests.md`
- Running tests rules: `.windsurf/rules/running_playwright_tests.md`
- Playwright docs: https://playwright.dev/docs/test-assertions
