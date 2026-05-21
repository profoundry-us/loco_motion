---
description: >
  Guide the full LocoMotion release process: bump version, build packages,
  finalize CHANGELOG, tag, and prepare for publishing. Use when asked to
  "release version X", "cut a release", or "start the release process".
  Must be on main with all changes merged before starting.
---

# Release

Begin the LocoMotion release process: `$ARGUMENTS`

`$ARGUMENTS` should be the new semantic version (e.g., `0.6.0`). If not
provided, ask for it before proceeding.

## Step 0 — Pre-Release Verification

```bash
git branch --show-current
```

If NOT on `main`, STOP and say:
> "You must be on `main` with all changes merged before releasing.
> Please run `git checkout main && git pull origin main` first."

Confirm main is up to date:
```bash
git fetch origin main
git status
```

If there are unpulled changes or the branch is behind, STOP and ask the
user to pull first.

## Step 1 — Set the Version

Prompt for the version if not provided in `$ARGUMENTS`. Then:

```bash
just version-set NEW_VERSION={version}
```

This updates `lib/loco_motion/version.rb` and creates a release checklist
in `docs/checklists/`.

Verify the version was set:
```bash
just version
```

## Step 2 — Lock Dependencies

Update the `loco` container to use the new version:
```bash
just loco-version-lock
```

> Note: `just demo-version-lock` requires the NPM package to be published
> first. Skip it for now and run it after publishing.

## Step 3 — Run All Tests

```bash
just loco-test
just demo-test
```

If any tests fail, STOP and fix them before continuing.

## Step 4 — Build Packages

Build the RubyGem:
```bash
just gem-build
```

Build the NPM package:
```bash
just npm-build
```

After both succeed, tell the user:
> "Packages built in `builds/rubygems/` and `builds/npm/`. Please
> manually verify their contents before I continue."

Wait for the user to confirm.

## Step 5 — Finalize CHANGELOG

1. Get today's date (YYYY-MM-DD format).
2. Open `CHANGELOG.md`.
3. Replace the `[Unreleased]` header with:
   ```
   ## [{version}] - {YYYY-MM-DD}
   ```
4. Add a new `[Unreleased]` section above it (empty, for future changes).
5. Update the link reference definitions at the bottom of the file if
   needed.

Show the user the proposed change and wait for confirmation before editing.

## Step 6 — Commit and Tag the Release

```bash
git add .
git commit -m 'docs: Finalize CHANGELOG for release v{version}'
git push
```

Tag the release:
```bash
git tag v{version}
git push origin v{version}
```

## Step 7 — Publishing (Manual Steps)

Tell the user that the following steps require credentials and MUST be
run manually:

```bash
# Publish RubyGem to RubyGems.org
just gem-publish

# Publish NPM package to NPM Registry
just npm-publish
```

After publishing, they should:
1. Run `just demo-version-lock` to update the demo app
2. Create a GitHub Release via the GitHub UI, using the tag `v{version}`
3. Copy the CHANGELOG entry as the release notes

## Step 8 — Mark Checklist Complete

Open the release checklist in `docs/checklists/release-checklist-v{version}.md`
and mark off all completed items.

Tell the user:
> "Automated preparation is complete. Please run the publishing commands
> above and create the GitHub Release manually."

## Resources

- Version file: `lib/loco_motion/version.rb`
- Release checklist template: `docs/templates/release_checklist.md`
- CHANGELOG: `CHANGELOG.md`
- Releasing rules: `.windsurf/rules/releasing.md`
- RubyGems: https://rubygems.org/gems/loco_motion-rails
- NPM: https://www.npmjs.com/package/@profoundry-us/loco_motion
- GitHub Releases: https://github.com/profoundry-us/loco_motion/releases
