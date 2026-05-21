---
name: run-tests
description: Runs the LocoMotion RSpec test suite inside the correct Docker
  container. Use when the user says "run tests", "run the test suite", "check
  tests", "just loco-test", "just demo-test", or "run specs".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Run Tests

Runs the LocoMotion or demo RSpec test suite inside the appropriate Docker
container and reports results.

## Instructions

### Step 1: Determine which test suite to run

| Goal | Command |
|------|---------|
| Library unit tests (default) | `just loco-test` |
| Demo application tests | `just demo-test` |
| Both suites | Run `just loco-test` first, then `just demo-test` |

When in doubt, run both.

### Step 2: Check the Makefile first

Before running anything, verify the target exists:

```bash
grep -E '^loco-test|^demo-test' Makefile justfile
```

Use the exact recipe name from the file.

### Step 3: Run the library tests

```bash
just loco-test
```

This executes `rspec` inside the `loco` Docker container. Equivalent manual
command:

```bash
docker compose exec -it loco bundle exec rspec
```

### Step 4: Run the demo tests (if needed)

```bash
just demo-test
```

Equivalent manual command:

```bash
docker compose exec -it demo bundle exec rspec
```

### Step 5: Interpret results

- **All green** — report the count of examples and confirm everything passes.
- **Failures** — copy the failure message and backtrace, identify the file and
  line number, then diagnose the root cause before suggesting a fix.
- **Pending examples** — note them but do not treat them as failures.

### Step 6: Fix failures before proceeding

If tests were run as a prerequisite for committing or deploying, do not
continue until all tests pass. Fix the failing code, then rerun the affected
suite to confirm.

## Examples

**Example 1 — standard pre-commit check**

User: "Run the tests before I commit"

```bash
just loco-test
just demo-test
```

Report: "All 142 examples pass. You are clear to commit."

**Example 2 — single spec file**

User: "Run just the badge component spec"

```bash
docker compose exec -it loco bundle exec rspec spec/components/daisy/data_display/badge_component_spec.rb
```

**Example 3 — run tests after adding a new component**

After creating a new component and its spec, run:

```bash
just loco-test
```

If the new spec file is not picked up, verify it is inside `spec/components/`
and follows the `_spec.rb` naming pattern.

## Troubleshooting

**Container not running** — Run `docker compose ps` to check container status.
Start containers with `docker compose up -d`.

**Bundle errors** — Run `docker compose exec -it loco bundle install` to
install missing gems.

**Tests time out** — Check for infinite loops or missing database seeds in the
failing spec. Run the spec in isolation to confirm.

**`just loco-test` command not found** — Check that `just` is installed and
you are running from the project root. Alternatively use the `docker compose
exec` form directly.
