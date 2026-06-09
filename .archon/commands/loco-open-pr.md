---
description: Commit the work, update the CHANGELOG, and open a DRAFT PR using the repo template.
argument-hint: (no arguments — reads workflow artifacts)
---

# Commit + Open Draft PR

**Workflow ID**: $WORKFLOW_ID

The `create-pr` skill is preloaded. Commit the new component and open a **draft**
PR for the maintainer to review. The full RSpec suites already ran in the
workflow's `verify` step — do NOT re-run them here unless the diff looks empty.

## Phase 1: GUARD

```bash
git status --porcelain
git diff --stat
```

If there are NO changes and nothing is staged AND the branch has no commits
ahead of `$BASE_BRANCH`, there is nothing to ship: write a short note to
`$ARTIFACTS_DIR/validation.md`, skip the rest, and report "no changes — no PR
created." Otherwise continue.

## Phase 2: LOAD

Read, if present: `$ARTIFACTS_DIR/naming.json`, `$ARTIFACTS_DIR/plan.md`,
`$ARTIFACTS_DIR/implementation.md`, `$ARTIFACTS_DIR/validation.md`. Use these to
describe the change and to report the honest test/e2e status.

## Phase 3: CHANGELOG

Add an entry to `CHANGELOG.md` under the `[Unreleased]` section (create the
section if missing), in the **Component Changes** subsection, describing the new
component. Wrap CHANGELOG lines at **110** characters; indent continuation lines
to align with the text after the `- ` marker. Append to the bottom of the
subsection; do not alter existing entries.

## Phase 4: COMMIT + PUSH

Stage and commit everything with a conventional message (single quotes preserve
the backticks):

```bash
git add -A
git commit -m 'feat({ComponentTitle}): Add {component_name} component

## Changes

### app/components/daisy/{group}/
- Add the {component_name} component class, template, parts, and YARD docs.

### spec + demo
- Add the RSpec spec, demo example view, and Playwright e2e test.

### lib/loco_motion/helpers.rb
- Register the {ClassName}Component.'
git push -u origin $(git branch --show-current)
```

## Phase 5: OPEN DRAFT PR

1. Read `.github/pull_request_template.md` and fill every section:
   - **Context** — why this component was added.
   - **Related Issues** — link with `Fixes #N` only if the request named an
     issue; otherwise leave the placeholder note.
   - **Type of Change** — mark `- [x] Component update/addition` (no spaces).
   - **Description** — what was built (parts, slots, options, demo examples).
   - **Checklist** — mark items `[x]` ONLY when true based on the artifacts
     (tests passed, YARD added, CHANGELOG updated). Leave unverified items `[ ]`.
   - **Additional Notes** — state the RSpec result and the Playwright e2e
     result from `validation.md`. If anything is red or skipped, say so plainly.
   Write the filled template to `$ARTIFACTS_DIR/pr-body.md`.
2. Confirm the PR is within limits (**<= 10 files, <= 500 changed lines**). If it
   exceeds either, note it prominently in Additional Notes so the maintainer can
   split it.
3. Create the draft PR:

```bash
gh pr create --draft \
  --base "$BASE_BRANCH" \
  --title "feat({ComponentTitle}): Add {ComponentTitle} component" \
  --body-file "$ARTIFACTS_DIR/pr-body.md"
```

4. Apply a label if available: `gh pr edit <number> --add-label "enhancement"`
   (skip silently if the label does not exist — never invent labels).

### PHASE_5_CHECKPOINT
- [ ] CHANGELOG updated under [Unreleased] › Component Changes
- [ ] Work committed and branch pushed
- [ ] Draft PR opened against `$BASE_BRANCH` with the template fully filled
- [ ] Test/e2e status reported honestly in the PR body

## Phase 6: REPORT

Reply with the PR URL, the file/line counts, and a one-line status (green / has
caveats). Save the URL to `$ARTIFACTS_DIR/.pr-url`.
