---
description: >
  Run all LocoMotion tests: RSpec for the library, RSpec for the demo app,
  and optionally Playwright end-to-end tests. Use when asked to "run tests",
  "check tests pass", or "verify nothing is broken". Pass "loco", "demo",
  or "playwright" to run only a subset.
---

# Run Tests

Run LocoMotion tests: `$ARGUMENTS`

## Determine Scope

Parse `$ARGUMENTS`:
- Empty or `all` → run all three test suites
- `loco` → run only the library RSpec suite
- `demo` → run only the demo app RSpec suite
- `playwright` or `e2e` → run only Playwright end-to-end tests
- `rspec` → run both `loco` and `demo` RSpec suites

## Step 1 — Library RSpec Tests

Run unless scope excludes `loco`:

```bash
just loco-test
```

This runs `bundle exec rspec spec` inside the `loco` Docker container.

- Review the output carefully.
- If any tests fail, report the failure with the file and line number.
- Do NOT proceed to the next suite if tests are failing.

## Step 2 — Demo App RSpec Tests

Run unless scope excludes `demo`:

```bash
just demo-test
```

This runs `bundle exec rspec spec` inside the `demo` Docker container.

- Review the output carefully.
- Report failures with file and line number.
- Do NOT proceed to Playwright if these tests are failing.

## Step 3 — Playwright End-to-End Tests

Run only when scope includes `playwright` or `all`:

```bash
docker compose exec -it demo yarn playwright test 'e2e' --reporter dot --workers 1
```

- Use `--workers 1` always (required for CI stability).
- Use `--reporter dot` always.
- To run a specific spec file:
  ```bash
  docker compose exec -it demo yarn playwright test \
    'e2e/daisy/actions/buttons.spec.ts' --reporter dot --workers 1
  ```
- To run a directory:
  ```bash
  docker compose exec -it demo yarn playwright test \
    'e2e/daisy/data_display/' --reporter dot --workers 1
  ```

## Reporting Results

After all requested suites run, summarize:

```
Test Results
────────────
Library RSpec:  ✓ X examples, 0 failures
Demo RSpec:     ✓ X examples, 0 failures
Playwright:     ✓ X passed, 0 failed
```

If any suite fails, report which files failed and suggest a fix before
proceeding with any commit.

## Resources

- Justfile: `justfile` (see `loco-test`, `demo-test`, `playwright` recipes)
- Running commands rules: `.windsurf/rules/running_commands.md`
- Playwright rules: `.windsurf/rules/running_playwright_tests.md`
- Demo e2e tests: `docs/demo/e2e/`
- Library specs: `spec/`
- Demo specs: `docs/demo/spec/`
