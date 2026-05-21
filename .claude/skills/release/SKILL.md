---
name: release
description: Guides the release process for a new LocoMotion version — bumping
  the version, building packages, finalizing the CHANGELOG, tagging, and
  publishing. Use when the user says "release a new version", "cut a release",
  "publish a release", "bump the version", or "ship a release".
metadata:
  author: profoundry-us
  version: 1.0.0
---

# Release

Executes the LocoMotion release process in the correct order. Most steps
require the user to confirm before running, and publishing steps must be run
manually by the user.

## Instructions

### Step 1: Verify you are on main and up to date

```bash
git branch --show-current
git pull origin main
```

Stop if NOT on `main`. Instruct the user to merge all changes first and switch
to `main`.

### Step 2: Determine the new version

Ask the user for the semantic version number (e.g. `1.2.3`). Do not guess.

Propose running:

```bash
make version-set NEW_VERSION=1.2.3
make version-lock
```

Wait for user confirmation before running.

### Step 3: Build packages

Propose in order:

```bash
make gem-build
make npm-build
```

After both succeed, inform the user to manually inspect:

- `builds/rubygems/` — gem artifact
- `builds/npm/` — npm artifact

### Step 4: Finalize the CHANGELOG

1. Confirm the version number with the user.
2. Get today's date in `YYYY-MM-DD` format.
3. Propose editing `CHANGELOG.md`: replace the `## [Unreleased]` header with:

   ```markdown
   ## [1.2.3] - 2025-06-15
   ```

4. Propose:

   ```bash
   git add CHANGELOG.md
   git commit -m 'docs: Finalize CHANGELOG for release v1.2.3'
   git push
   ```

### Step 5: Tag the release

Determine the current version:

```bash
make version
```

Propose:

```bash
git tag v1.2.3
git push origin v1.2.3
```

### Step 6: Prepare publishing commands

Inform the user that these steps require external credentials and MUST be run
manually:

```bash
make gem-publish
make npm-publish
```

Do NOT run these commands yourself. Provide them for the user to copy/paste.

### Step 7: Final steps (manual)

Remind the user to:

1. Create the GitHub release via the UI using the tag just pushed.
2. Copy the relevant CHANGELOG section as the release notes.
3. Attach the built artifacts if required.

### Step 8: Update the checklist

Report which steps are complete and which are pending manual action.

## Examples

**Example 1 — full release flow summary**

```
Release v1.3.0 checklist:

✓ On main, pulled latest
✓ Version set to 1.3.0 (make version-set + make version-lock)
✓ Gem built: builds/rubygems/loco_motion-1.3.0.gem
✓ npm built: builds/npm/
✓ CHANGELOG finalized for v1.3.0
✓ Committed and pushed CHANGELOG
✓ Tagged v1.3.0 and pushed tag

Pending (manual):
  make gem-publish
  make npm-publish
  Create GitHub Release via UI
```

## Troubleshooting

**`make version-set` fails** — Check that `NEW_VERSION` is a valid semver
string (no `v` prefix). Example: `NEW_VERSION=1.3.0`, not `NEW_VERSION=v1.3.0`.

**Tag already exists** — Run `git tag -l "v1.3.0"` to confirm. If it was
pushed prematurely, coordinate with the team before deleting a published tag.

**gem-publish / npm-publish credential errors** — These require RubyGems and
npm credentials configured in the user's environment. Claude cannot provide
credentials or run these commands.

**CHANGELOG has no `[Unreleased]` section** — Ask the user if changes were
logged during development. If not, collect them from `git log` and add them
before finalizing.
