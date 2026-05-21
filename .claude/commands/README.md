# LocoMotion Claude Skills

Custom Claude Code slash commands for building LocoMotion components.

## Available Commands

| Command              | Description                                       |
|----------------------|---------------------------------------------------|
| `/new-component`     | Scaffold all files for a new DaisyUI component    |
| `/modify-component`  | Modify an existing component following standards  |
| `/document-component`| Add/improve YARD docs for a component             |
| `/run-tests`         | Run RSpec and/or Playwright tests                 |
| `/commit-and-push`   | Run tests, commit with Markdown message, and push |
| `/create-plan`       | Create an implementation plan in `docs/plans/`    |
| `/start-issue`       | Begin work on a GitHub issue                      |
| `/create-pr`         | Generate PR description and update CHANGELOG      |
| `/update-changelog`  | Add entries to CHANGELOG for current branch       |
| `/playwright-tests`  | Write and/or run Playwright e2e tests             |
| `/code-check`        | Verify changed files against coding standards     |
| `/release`           | Guide the full release process                    |

## Usage

In any Claude Code session, type `/command-name [arguments]` to invoke
a skill. For example:

```
/new-component button_group actions
/run-tests playwright
/start-issue 123
/release 0.6.0
```

## Shared Scripts

The `shared_scripts/` directory contains Go programs used by multiple
commands. To run them:

```bash
# Check branch naming convention
go run .claude/commands/shared_scripts/check_branch/main.go

# Validate all component files exist
go run .claude/commands/shared_scripts/validate_component/main.go \
  button actions
```

Install Go if needed: https://go.dev/doc/install

## Directory Structure

```
.claude/commands/
├── README.md                        ← This file
├── new-component.md
├── modify-component.md
├── document-component.md
├── run-tests.md
├── commit-and-push.md
├── create-plan.md
├── start-issue.md
├── create-pr.md
├── update-changelog.md
├── playwright-tests.md
├── code-check.md
├── release.md
└── shared_scripts/
    ├── check_branch/
    │   └── main.go                  ← Branch name validator
    └── validate_component/
        └── main.go                  ← Component file validator
```

## Tracking These Files

These files live in `.claude/commands/`, which is excluded by the root
`.gitignore`. They are force-tracked in this repository to share them
with all contributors. If you clone fresh and they are not present,
run:

```bash
git checkout .claude/commands/
```
