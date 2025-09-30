# Release Checklist Template

Use this checklist to ensure all steps are completed for a LocoMotion release.

## Pre-Release Preparation

- [ ] All tests are passing locally: `make loco-test`
- [ ] All documentation is up to date and properly formatted
- [ ] All changes are committed and pushed to the main branch
- [ ] You have the necessary credentials for both RubyGems.org and NPM
- [ ] Review any breaking changes and update documentation accordingly

## Phase 1: Package Release

### Step 1 - Version Update
- [ ] Update version: `make version-bump` or `make version-set NEW_VERSION=x.y.z`
- [ ] Review version changes: `git diff`
- [ ] Update loco container: `make loco-version-lock` (safe to run anytime)
- [ ] **Note**: Do NOT run `make demo-version-lock` at this stage

### Step 2 - Update Changelog
- [ ] Add new version section to `CHANGELOG.md`
- [ ] Include all relevant changes since last release
- [ ] Use proper formatting consistent with existing entries

### Step 3 - Building and Testing
- [ ] Build Ruby gem: `make gem-build`
- [ ] Verify gem build in `builds/rubygems/loco_motion-rails-[VERSION].gem`
- [ ] Build NPM package: `make npm-build`
- [ ] Verify NPM package in `builds/npm/profoundry-us-loco_motion-[VERSION].tgz`

### Step 4 - Create Release PR
- [ ] Commit all changes: `git commit -am "Release version x.y.z"`
- [ ] Create pull request with release changes
- [ ] Get pull request reviewed and approved
- [ ] Merge pull request into main
- [ ] Pull latest main locally: `git checkout main && git pull`

### Step 5 - Publish Packages
- [ ] Create and push version tag: `git tag vx.y.z && git push origin vx.y.z`
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

## Troubleshooting

### If `make demo-version-lock` fails:
1. Verify NPM package was published successfully
2. Check NPM registry: `npm view @profoundry-us/loco_motion@x.y.z`
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

**Release Version**: ___________  
**Release Date**: ___________  
**Released By**: ___________
