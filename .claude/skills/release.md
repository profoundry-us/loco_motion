---
description: >
  Guide the full LocoMotion release process from version bump through
  package builds, CHANGELOG finalization, and git tagging. Use when
  asked to release, cut a release, or start the release process.
  Must be on main with all changes merged first.
---

# Release

## When to Use

- "Release version 0.6.0"
- "Cut a release"
- "Start the release process"

Ask for the version number if not provided.

## Step 0 — Pre-Release Checks

```bash
git branch --show-current
```

If **not** on `main`, stop:
> "Releases must be cut from `main`. Please merge all changes and run
> `git checkout main && git pull origin main` first."

Check main is up to date:
```bash
git fetch origin main
git status
```

## Step 1 — Bump the Version

```bash
just version-set NEW_VERSION={version}
```

Verify:
```bash
just version
```

This also creates a checklist at
`docs/checklists/release-checklist-v{version}.md`.

## Step 2 — Lock `loco` Dependencies

```bash
just loco-version-lock
```

> Note: `just demo-version-lock` needs the NPM package published first.
> Skip it here; run it after publishing.

## Step 3 — Run All Tests

```bash
just loco-test
just demo-test
```

Stop and fix any failures before continuing.

## Step 4 — Build Packages

```bash
just gem-build
just npm-build
```

After both succeed:
> "Packages built in `builds/rubygems/` and `builds/npm/`. Please
> verify their contents manually, then let me know to continue."

Wait for the user's confirmation.

## Step 5 — Finalize CHANGELOG

1. Get today's date (YYYY-MM-DD).
2. In `CHANGELOG.md`, replace the `## [Unreleased]` header with:
   ```
   ## [{version}] - {YYYY-MM-DD}
   ```
3. Add a new empty `## [Unreleased]` section above it for future entries.
4. Update the link reference definitions at the bottom if needed.

Show the proposed diff and wait for confirmation before editing.

## Step 6 — Commit and Tag

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

## Step 7 — Publishing (Manual — Requires Credentials)

Inform the user these steps need to be run manually:

```bash
just gem-publish      # pushes to RubyGems.org
just npm-publish      # pushes to npmjs.com
just demo-version-lock  # after npm package is live
```

After publishing they should:
1. Create a GitHub Release via the UI using tag `v{version}`
2. Paste the CHANGELOG section as the release notes

## Step 8 — Mark the Checklist

Open `docs/checklists/release-checklist-v{version}.md` and mark off
all automated steps as complete. Note which steps require manual action.

## Resources

- Version file: `lib/loco_motion/version.rb`
- Release checklist template: `docs/templates/release_checklist.md`
- CHANGELOG: `CHANGELOG.md`
- Releasing rules: `.windsurf/rules/releasing.md`
- RubyGems: https://rubygems.org/gems/loco_motion-rails
- NPM: https://www.npmjs.com/package/@profoundry-us/loco_motion
- GitHub Releases: https://github.com/profoundry-us/loco_motion/releases
