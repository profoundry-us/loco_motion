# Plan: Automated Release Workflow (release.yml)

## Overview

Today, publishing LocoMotion is a fully manual process driven by the
interactive `bin/release` wizard, which builds and pushes both the RubyGem and
the npm package from a maintainer's local machine using their personal
credentials. This plan describes adding a tag-triggered GitHub Actions workflow
(`.github/workflows/release.yml`) that builds, verifies, and publishes both
packages automatically using **OIDC trusted publishing** (no long-lived
secrets).

This is a **future PR** — it is intentionally separate from the standards pass
in [202605-4](202605-4-architecture-and-standards-review.md) because it
requires account-level configuration on RubyGems.org and npmjs.com that only a
maintainer can perform, and it cannot be tested from a development sandbox.

This corresponds to Tier 2.6 of the architecture review.


## External Resources

- [RubyGems Trusted Publishing](https://guides.rubygems.org/trusted-publishing/)
- [npm Trusted Publishing / provenance](https://docs.npmjs.com/generating-provenance-statements)
- [GitHub OIDC hardening](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [rubygems/release-gem action](https://github.com/rubygems/release-gem)
- Current manual process: `bin/release`, `docs/dev_guides/RELEASING.md`

## Prerequisites (maintainer, one-time)

These must be done **before** the workflow can publish; the workflow PR should
not be merged until they are in place:

1. On RubyGems.org, configure a **Trusted Publisher** for the
   `loco_motion-rails` gem pointing at this repo + the `release.yml` workflow.
2. On npmjs.com, configure trusted publishing (or a granular automation token
   stored as an Actions secret) for `@profoundry-us/loco_motion`.
3. Create a GitHub Actions **Environment** named `release` with required
   reviewers, so a human approves each publish.


## Implementation Steps

### 1. Confirm the version single-source-of-truth check

**Purpose**: The workflow must refuse to publish if the four version locations
disagree.

**Files to Review**: `lib/loco_motion/version.rb`, `VERSION`, `package.json`,
`docs/demo/package.json`, the `version-check` recipe added to the `justfile` in
the 202605-4 pass.

**Key Concerns**:

- The tag being built (`v1.2.3`) must equal `LocoMotion::VERSION`.
- Fail fast with a clear message on any mismatch.

### 2. Add `.github/workflows/release.yml`

**Purpose**: Build, verify, and publish on tag push.

**Trigger**: `on: push: tags: ['v*']`.

**Permissions**: `id-token: write` (OIDC) and `contents: write` (for the
GitHub Release); nothing else.

**Jobs / steps**:

1. Checkout, set up Ruby (matching `.ruby-version`) and Node (via
   `node-version-file: .node-version`).
2. `bundle install` (frozen) and run the **full test suite** — reuse the same
   steps as `cicd.yml` rather than duplicating them; do not publish if tests
   fail.
3. Run the `version-check` to assert the tag matches `LocoMotion::VERSION`.
4. Build the gem and the npm package (`just gem-build` / `just npm-build`).
5. Publish the gem via RubyGems trusted publishing
   (`rubygems/release-gem` or `gem push` with the OIDC token).
6. Publish the npm package with `npm publish --provenance --access public`.
7. Create a GitHub Release from `CHANGELOG.md` for that version.

Wrap steps 5–7 in the `release` environment so they require manual approval.

### 3. Reduce `bin/release` to a local-only fallback

**Purpose**: Avoid two divergent release paths.

**Files to Edit**: `bin/release`, `docs/dev_guides/RELEASING.md`.

**Changes to Make**:

- Keep `bin/release` for emergency local publishing, but document the
  GitHub Actions workflow as the **primary** path.
- The `make`→`just` fix from 202605-4 stays; this plan does not re-do it.
- Update `RELEASING.md` to describe the new tag-and-approve flow.

### 4. Verification

**Purpose**: Prove the pipeline before trusting it with a real version.

**Commands / process**:

```bash
# Dry-run on a pre-release tag that the workflow treats as non-publishing,
# or use the registries' dry-run/--dry-run equivalents in a fork first.
git tag v0.0.0-rc.test && git push origin v0.0.0-rc.test
```

**Expected Results**:

- Workflow runs tests, passes version-check, builds both packages.
- Publish steps wait on `release` environment approval.
- After approval, gem + npm versions appear with provenance; a GitHub Release
  is created. Then delete the test tag/release.


## Risks & Notes

- **Cannot be validated from a sandbox** — needs the registry trusted-publisher
  config and a real (or forked) GitHub Actions run.
- Trusted publishing removes the need to store `GEM_HOST_API_KEY` / npm tokens
  as secrets — prefer it over token-based auth.
- Keep the `release` environment gated so a tag push alone never publishes
  without a human approving.
