# LocoMotion Claude Skills

Claude Skills for building LocoMotion DaisyUI ViewComponents consistently.

## Available Skills

| Skill | Purpose |
|-------|---------|
| `new-component` | Scaffold all files for a new component |
| `modify-component` | Update an existing component |
| `document-component` | Write or improve YARD docs |
| `run-tests` | Run the RSpec suite (loco or demo) |
| `commit-and-push` | Stage, commit, and push changes |
| `create-plan` | Generate an implementation plan |
| `start-issue` | Read a GitHub issue and set up a branch |
| `create-pr` | Draft a PR description and open the PR |
| `update-changelog` | Add entries to CHANGELOG.md |
| `playwright-tests` | Write and run Playwright e2e tests |
| `code-check` | Review code against project conventions |
| `release` | Guide the version-bump and release flow |

## Shared Scripts

Reusable Python scripts live in `shared-scripts/`:

| Script | Purpose |
|--------|---------|
| `check_branch.py` | Validates the current git branch name |
| `validate_component.py` | Confirms all component files exist |

Run from the project root:

```bash
python .claude/skills/shared-scripts/check_branch.py
python .claude/skills/shared-scripts/validate_component.py button actions
```

## Key Conventions

- **DaisyUI variants**: Never add `size:` or `color:` params to components.
  Use `css: "btn-primary btn-lg"` instead.
- **YARD docs**: Use `@loco_example` (not `@example`). All `@param`/`@option`
  tags go on `initialize`, not the class.
- **Docker**: Library commands run in the `loco` container; demo commands in
  the `demo` container.
- **Playwright**: Always use `--reporter dot --workers 1`.
- **Commits**: Surround messages in single quotes. Use the Markdown body for
  details.
