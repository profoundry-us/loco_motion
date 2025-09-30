# Release Checklist for v0.5.1

Use this checklist to ensure all steps are completed for the LocoMotion 0.5.1 release.

## Pre-Release Preparation

- [x] All tests are passing locally: `make loco-test`
- [x] All documentation is up to date and properly formatted
- [ ] All changes are committed and pushed to the main branch
- [ ] You have the necessary credentials for both RubyGems.org and NPM
- [x] Review any breaking changes and update documentation accordingly

## Phase 1: Package Release

### Step 1 - Version Update
- [x] Update version: `make version-bump` or `make version-set NEW_VERSION=0.5.1`
- [x] Review version changes: `git diff`
- [ ] Update loco container: `make loco-version-lock` (safe to run anytime)
- [x] **Note**: Do NOT run `make demo-version-lock` at this stage

### Step 2 - Update Changelog
- [x] Add new version section to `CHANGELOG.md`
- [x] Include all relevant changes since last release
- [x] Use proper formatting consistent with existing entries

### Step 3 - Building and Testing
- [ ] Build Ruby gem: `make gem-build`
- [ ] Verify gem build in `builds/rubygems/loco_motion-rails-0.5.1.gem`
- [ ] Build NPM package: `make npm-build`
- [ ] Verify NPM package in `builds/npm/profoundry-us-loco_motion-0.5.1.tgz`

### Step 4 - Create Release PR
- [ ] Commit all changes: `git commit -am "Release version 0.5.1"`
- [ ] Create pull request with release changes
- [ ] Get pull request reviewed and approved
- [ ] Merge pull request into main
- [ ] Pull latest main locally: `git checkout main && git pull`

### Step 5 - Publish Packages
- [ ] Create and push version tag: `git tag v0.5.1 && git push origin v0.5.1`
- [ ] Publish Ruby gem: `make gem-publish`
- [ ] Verify gem on [RubyGems.org](https://rubygems.org/gems/loco_motion-rails)
- [ ] Publish NPM package: `make npm-publish`
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

## Completed Work Summary

### ✅ What's Been Done:
- **Version Update**: Updated to 0.5.1 in all files
- **CHANGELOG**: Added comprehensive 0.5.1 section with:
  - DaisyUI/TailwindCSS updates
  - Alpha status badge removal
  - Complete release process improvements documentation
- **Release Process Improvements**:
  - Refactored Makefile commands (`loco-version-lock`, `demo-version-lock`)
  - Created post-release automation script
  - Updated documentation with two-phase approach
  - Created release checklist template
  - Improved error handling and validation

### 🔄 Next Steps:
1. Run tests to ensure everything is working
2. Update loco container with `make loco-version-lock`
3. Build and verify packages
4. Commit and create release PR

## Troubleshooting

### If `make demo-version-lock` fails:
1. Verify NPM package was published successfully
2. Check NPM registry: `npm view @profoundry-us/loco_motion@0.5.1`
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

**Release Version**: 0.5.1
**Release Date**: 2025-09-25
**Released By**: ___________
