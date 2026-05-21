# LocoMotion Claude Skills

AI-readable skill files that help Claude understand how to build,
test, and ship LocoMotion components following all project conventions.

## Skills

| File                      | Purpose                                           |
|---------------------------|---------------------------------------------------|
| `new-component.md`        | Scaffold all files for a new DaisyUI component    |
| `modify-component.md`     | Modify an existing component correctly            |
| `document-component.md`   | Write YARD docs with proper tags and examples     |
| `run-tests.md`            | Run RSpec and/or Playwright tests                 |
| `commit-and-push.md`      | Test → stage → commit (Markdown message) → push   |
| `create-plan.md`          | Create an implementation plan in `docs/plans/`    |
| `start-issue.md`          | Read a GitHub issue and set up a branch           |
| `create-pr.md`            | Generate PR description, update CHANGELOG, open   |
| `update-changelog.md`     | Add categorized entries to `CHANGELOG.md`         |
| `playwright-tests.md`     | Write and/or run Playwright e2e specs             |
| `code-check.md`           | Audit changed files against coding standards      |
| `release.md`              | Guide the full release process                    |

## Shared Scripts

Python utilities used by multiple skills:

```
shared_scripts/
  check_branch.py         Branch name convention validator
  validate_component.py   Component file existence checker
```

**Run from the project root:**

```bash
# Check branch name
python .claude/skills/shared_scripts/check_branch.py

# Validate component files
python .claude/skills/shared_scripts/validate_component.py button actions
python .claude/skills/shared_scripts/validate_component.py text_input data_input
```

Python 3.6+ required; no third-party dependencies.

## Git Tracking

The root `.gitignore` excludes only Claude-specific personal files
(`settings.local.json`, `todos/`, `cache/`). Everything in `skills/`
is tracked normally.
