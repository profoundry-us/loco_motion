# LocoMotion — Claude Instructions


## Project Overview

LocoMotion is a Rails ViewComponent library (v0.6.0) that wraps DaisyUI
components with a clean Ruby API. It generates semantic, accessible UI
elements using Tailwind CSS classes and ships with a live demo application
for previewing and testing every component.

**Key repositories / paths:**

- `app/components/daisy/` — all component classes and HAML templates
- `spec/components/daisy/` — RSpec unit tests
- `docs/demo/` — the standalone Rails demo app
- `docs/demo/app/views/examples/daisy/` — example views shown in the demo
- `lib/loco_motion/` — core library helpers and component registry
- `lib/loco_motion/helpers.rb` — component registration map
- `.claude/skills/` — Claude Skills (see below)
- `.devin/rules/` — detailed rule files (additional reference)
- `docs/plans/` — implementation plans for larger features and refactoring


## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Ruby (Rails ViewComponent) |
| Styling | Tailwind CSS + DaisyUI |
| Templates | HAML |
| Unit tests | RSpec |
| E2E tests | Playwright (TypeScript) |
| Task runner | `just` (see `justfile`) |
| Environment | Docker Compose (`loco` + `demo` containers) |
| Docs | YARD with custom `@loco_example` tag |


## Component Groups

Components live under `app/components/daisy/{group}/`:

| Group | Purpose |
|-------|---------|
| `actions` | Buttons, dropdowns, modals, swaps |
| `data_display` | Cards, badges, avatars, stats, tables |
| `data_input` | Form inputs, selects, checkboxes |
| `feedback` | Alerts, toasts, progress, loading |
| `layout` | Dividers, drawers, stack, hero |
| `mockup` | Phone, browser, window mockups |
| `navigation` | Navbar, breadcrumbs, tabs, pagination |


## Docker & Commands

All Ruby commands run inside Docker containers:

| Container | Use for |
|-----------|---------|
| `loco` | Library code, RSpec, bundle |
| `demo` | Demo app, Playwright, demo RSpec |

**Always use `just` — never `make`:**

```bash
just loco-test      # Run library RSpec suite
just demo-test      # Run demo RSpec suite
just demo-restart   # Restart demo app (only when lib/loco_motion changes)
just playwright     # Run all Playwright e2e tests
```

Raw Docker form (when `just` target doesn't exist):

```bash
docker compose exec -it loco bundle exec rspec
docker compose exec -it demo bundle exec rspec
docker compose exec -it demo yarn playwright test 'e2e/...' \
  --reporter dot --workers 1
```

**Critical command rules:**

- NEVER use `cd` before any command — always run from the project root.
- NEVER change the Ruby version.
- ALWAYS check `justfile` for an existing target before writing raw Docker
  commands.
- Only restart the demo app when files inside `lib/loco_motion/` change.

### Remote / cloud sessions (Claude Code on the web)

In the remote execution environment (`CLAUDE_CODE_REMOTE=true`) the Docker
CLI is present but the daemon is **not** started and `just` is **not**
installed, so the targets above fail until the session is bootstrapped. Run
this once at the start of the session:

```bash
bin/setup-docker
```

It starts the Docker daemon (with a `mirror.gcr.io` pull-through cache so
anonymous base-image pulls avoid Docker Hub's rate limit), installs `just`,
bakes the environment's egress-proxy CAs into the `ruby:3.4.4` base so
in-container HTTPS verifies, and builds and starts the `loco` and `demo`
containers. Afterwards the `just` targets above work as normal.

- The script is idempotent — re-running skips anything already done, and it
  is a no-op locally where Docker and `just` already exist.
- `bin/setup-docker --skip-build` starts the daemon and installs `just`
  without building or starting any containers.
- If base-image pulls still fail with `HTTP 429`, set `DOCKERHUB_USERNAME`
  and `DOCKERHUB_TOKEN` in the environment config and re-run.


## Branch & Commit Conventions

**Branch naming:** `{type}-{optional-issue-number}-{description}`

- Valid types: `feat`, `bug`, `fix`, `task`, `chore`, `docs`, `refactor`,
  `claude`
- Examples: `feat-45-add-badge-icon`, `docs-update-card-docs`
- NEVER work directly on `main`.

**Commit messages:**

- First line: `feat(Badge): Add icon part` (type, scope, imperative summary)
- Body: Markdown with `##` headers and bullet lists per file/area
- Surround the entire message in **single quotes** when passing to
  `git commit -m` so backticks in the body are preserved.
- Append `Fixes #N` when the branch contains an issue number.


## Pull Request Size & Scope

**Hard limits:**

- **500 lines or fewer** (additions + deletions combined)
- **10 files or fewer** (including tests and docs)

If a PR exceeds either limit, stop and split it before opening.

**The core rule:** if you need the word "and" to describe a PR, it should
be two PRs. One PR → one logical concern.

**How to split large changes:**

1. **Infrastructure first** — refactoring, extractions, base-class changes,
   and config updates each get their own PR. Land them before the feature
   that depends on them.
2. **One component per PR** — when adding or migrating ViewComponents, each
   component (class + template + spec + demo example) is one PR. Never batch
   multiple components.
3. **Docs/YARD separately** — if documentation is substantial, open a
   follow-up PR rather than bloating the implementation PR.
4. **Tests can lead** — it is fine (and encouraged) to open a spec-only PR
   first, then the implementation PR.
5. **Migrations and setup standalone** — dependency bumps, initializers, and
   schema changes each deserve their own reviewed PR.

**Warning signs a PR is too big:**

- The PR description has more than three bullet points under "Changes".
- A reviewer would need to context-switch between unrelated areas of the
  codebase.
- CI touches files in more than two component groups.

**Why it matters:** Review quality drops sharply above 400 lines — defect
detection falls from ~87% (small PRs) to ~42% (600+ lines). Smaller PRs
also unblock teammates faster and make git bisect reliable.


## Component Conventions

**DaisyUI variants — critical rule:**
Never add `size:`, `color:`, or other visual-variant parameters to a
component. Users apply DaisyUI classes directly:

```ruby
# CORRECT
daisy_button(css: "btn-primary btn-lg")

# WRONG — never do this
daisy_button(color: :primary, size: :lg)
```

**Parts:**
- Declare with `define_part :name` in the class.
- NEVER define `part(:component)` — `BaseComponent` handles it.
- NEVER add `_css` or `_html` properties for parts — also handled by
  `BaseComponent`.
- Most components use `= part(:component) do` as the root of the template;
  exceptions include components that use `LabelableComponent` or similar
  concerns that wrap the root.

**Slots:**
- Declare with `renders_one :name, ComponentClass` or `renders_many :name+`.


## YARD Documentation

- Use `@loco_example` (NOT `@example`) for all code examples.
- Examples must use HAML syntax with `daisy_` helper methods.
- All `@param` and `@option` tags go on `initialize`, never on the class.
- Required class-level doc order:
  description → `@note` → `@part` → `@slot` → `@loco_example`.
- Add a blank line between each `@param` / `@option` entry.
- Wrap all doc lines at 80 characters.


## Markdown / Documentation

- Wrap lines at 80 characters.
- Exception: wrap `CHANGELOG.md` entries at 110 characters — the longer limit
  keeps each entry readable. Indent continuation lines to align with the text
  after the list marker (2 spaces under a top-level `- `, 4 under a nested
  `  - `).
- Exception: text that GitHub renders — pull request descriptions, issue
  bodies, and PR / issue comments — is exempt from line wrapping. GitHub
  reflows it as prose, so the 80-character limit does not apply; do NOT
  hard-wrap it. Write natural paragraphs (one line each) and let them wrap on
  render. This covers only content posted to GitHub — Markdown files in the
  repo (`README`, `docs/`, `CLAUDE.md`, the skills) still wrap at 80.
- Never split an inline code span (`` `...` ``), a Markdown link
  (`[text](url)`), or a `<code>` tag across lines. A line may exceed its limit
  only when one such unbreakable token is itself too long; prose must always
  wrap.
- Add a newline after every header.
- Use two newlines before H1 headings.


## Communication Shortcuts

- `ta` → try again
- `cont` → continue
- If a message starts with a CLI tool name (`git`, `just`, `docker`, etc.),
  execute it directly without asking for confirmation.


## Using Claude Skills

For any substantial task, use the matching Claude Skill — it contains the
full step-by-step procedure, examples, and troubleshooting.

| Task | Skill |
|------|-------|
| Create a new component | `new-component` |
| Modify an existing component | `modify-component` |
| Write or improve YARD docs | `document-component` |
| Run the test suite | `run-tests` |
| Stage, commit, and push | `commit-and-push` |
| Write a pre-commit code review | `code-check` |
| Create an implementation plan | `create-plan` |
| Investigate and file a GitHub issue | `create-issue` |
| Start work on an existing GitHub issue | `start-issue` |
| Open a pull request | `create-pr` |
| Update the CHANGELOG | `update-changelog` |
| Write or run Playwright tests | `playwright-tests` |
| Boot the demo app locally | `run-demo` |
| Screenshot / video a demo page | `screenshot-demo` |

Skills live in `.claude/skills/{skill-name}/SKILL.md`. Shared helper
scripts are in `.claude/skills/shared-scripts/`.
