---
description: >
  Run any combination of LocoMotion's three test suites: library RSpec,
  demo app RSpec, and Playwright end-to-end tests. Use when the user asks
  to run tests, check if tests pass, or verify nothing is broken after
  making changes. Also run automatically before committing.
---

# Run Tests

## When to Use

- "Run the tests"
- "Do the tests pass?"
- "Check nothing is broken"
- "Run the playwright tests for buttons"
- Before every commit (see `commit-and-push` skill)

## Determine Scope

| Argument      | Runs                                    |
|---------------|-----------------------------------------|
| (empty)       | All three suites                        |
| `loco`        | Library RSpec only                      |
| `demo`        | Demo app RSpec only                     |
| `rspec`       | Both RSpec suites                       |
| `playwright`  | Playwright e2e only                     |
| `all`         | All three suites                        |

## Library RSpec

```bash
just loco-test
```

Runs `bundle exec rspec spec` inside the `loco` Docker container.

- If any example fails, report the file + line number and stop.
- Do not continue to other suites while failures exist.

## Demo App RSpec

```bash
just demo-test
```

Runs `bundle exec rspec spec` inside the `demo` Docker container.

- Report failures with file + line number.

## Playwright End-to-End

**Full suite:**
```bash
docker compose exec -it demo yarn playwright test 'e2e' \
  --reporter dot --workers 1
```

**Single spec file:**
```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/actions/buttons.spec.ts' --reporter dot --workers 1
```

**A whole directory:**
```bash
docker compose exec -it demo yarn playwright test \
  'e2e/daisy/data_display/' --reporter dot --workers 1
```

Always use `--reporter dot` and `--workers 1`.

## Reading Results

`--reporter dot` output:
- `.` = passed
- `F` = failed
- `E` = error (setup/teardown issue)

If Playwright tests fail, the most common causes are:
1. Nav link title doesn't match the sidebar — re-read the example HAML
2. Heading text mismatch — check `doc_example(title: "...")` values
3. Demo app not running — run `just status` to check containers

## Summary Format

After all requested suites complete, report:

```
Test Results
────────────
Library RSpec : ✓  42 examples, 0 failures
Demo RSpec    : ✓  18 examples, 0 failures
Playwright    : ✓  31 passed,   0 failed
```

## Resources

- Justfile: `justfile` (see `loco-test`, `demo-test`, `playwright`)
- Running commands rules: `.windsurf/rules/running_commands.md`
- Playwright rules: `.windsurf/rules/running_playwright_tests.md`
- Library specs: `spec/`
- Demo specs: `docs/demo/spec/`
- E2e specs: `docs/demo/e2e/`
