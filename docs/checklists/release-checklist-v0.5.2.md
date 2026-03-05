# Release Checklist for v0.5.2

Use this checklist to ensure all steps are completed for a LocoMotion release.

## Pre-Release Preparation

- [x] All tests are passing locally: `make loco-test`
- [x] All documentation is up to date and properly formatted
- [x] All changes are committed and pushed to the main branch
- [ ] You have the necessary credentials for both RubyGems.org and NPM
- [x] Review any breaking changes and update documentation accordingly

## Phase 1: Package Release

### Step 1 - Version Update
- [x] Update version: `make version-bump` or `make version-set NEW_VERSION=0.5.2`
- [x] Review version changes: `git diff`
- [x] Update loco container: `make loco-version-lock` (safe to run anytime)
- [x] **Note**: Do NOT run `make demo-version-lock` at this stage

### Step 2 - Update Changelog
- [x] Add new version section to `CHANGELOG.md`
- [x] Include all relevant changes since last release
- [x] Use proper formatting consistent with existing entries

### Step 3 - Building and Testing
- [x] Build Ruby gem: `make gem-build`
- [x] Verify gem build in `builds/rubygems/loco_motion-rails-0.5.2.gem`
- [x] Build NPM package: `make npm-build`
- [x] Verify NPM package in `builds/npm/profoundry-us-loco_motion-0.5.2.tgz`

### Step 4 - Create Release PR
- [x] Commit all changes: `git commit -am "Release version 0.5.2"`
- [x] Create pull request with release changes
- [x] Get pull request reviewed and approved
- [x] Merge pull request into main
- [x] Pull latest main locally: `git checkout main && git pull`

### Step 5 - Publish Packages
- [x] Create and push version tag: `git tag v0.5.2 && git push origin v0.5.2`
- [ ] Publish Ruby gem: `make gem-publish` (requires manual execution with credentials)
- [ ] Verify gem on [RubyGems.org](https://rubygems.org/gems/loco_motion-rails)
- [ ] Publish NPM package: `make npm-publish` (requires manual execution with credentials)
- [ ] Verify package on [npmjs.com](https://www.npmjs.com/package/@profoundry-us/loco_motion)

### Step 6 - GitHub Release
- [ ] Go to [releases page](https://github.com/profoundry-us/loco_motion/releases)
- [ ] Click "Draft a new release"
- [ ] Select the version tag you created
- [ ] Add release notes (GitHub AI tool can help)
- [ ] Publish the release

## Phase 2: Demo App Update

### Step 7 - Update Demo App
- [ ] Run post-release script: `bin/update_demo_after_release`
- [ ] Verify the script completes successfully
- [ ] Check that demo app dependencies are updated

### Step 8 - Verify Deployment
- [ ] Monitor demo app deployment on hosting platform
- [ ] Verify demo app loads correctly with new version
- [ ] Test key functionality on demo site
- [ ] Verify Algolia indexing completes successfully

## Post-Release Verification

- [ ] Demo site displays correct version number
- [ ] All components render correctly on demo site
- [ ] Search functionality works properly
- [ ] API documentation is accessible and current
- [ ] No broken links or missing assets

## Troubleshooting

### If `make demo-version-lock` fails:
1. Verify NPM package was published successfully
2. Check NPM registry: `npm view @profoundry-us/loco_motion@0.5.2`
3. Wait a few minutes for NPM registry propagation
4. Try again

### Available version lock commands:
- `make loco-version-lock`: Updates only loco container (safe anytime)
- `make demo-version-lock`: Updates only demo app (requires published NPM package)

### If demo app deployment fails:
1. Check hosting platform logs
2. Verify all dependencies are available
3. Check for any breaking changes in dependencies
4. Consider rolling back if critical issues found

### If Algolia indexing fails:
1. Check Algolia credentials and configuration
2. Verify demo app can connect to Algolia
3. Manually trigger reindexing if needed
4. Check Algolia dashboard for errors

## Notes

- **Two-Phase Process**: This process is split into two phases to avoid circular dependencies between package publication and demo app updates.
- **Auto-Deployment**: The demo app auto-deploys on every commit, so Phase 2 creates a separate commit after packages are published.
- **Version Consistency**: Always ensure the demo app uses the exact same version as the published packages.

---

**Release Version**: 0.5.2
**Release Date**: 2026-03-05
**Released By**: AI-Assisted Release Preparation
