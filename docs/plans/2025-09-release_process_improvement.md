# Release Process Improvement Plan

## Overview

This plan addresses the circular dependency issue in the current release process where `make version-lock` fails because it tries to install an NPM package that hasn't been published yet. The solution involves splitting the release process into two phases: package release and demo app update.

## Problem Statement

Currently, the release process has a circular dependency:
1. Step 1 requires running `make version-lock` after version update
2. `version-lock` tries to install the NPM package from the registry
3. The NPM package isn't published until Step 4
4. The demo app auto-deploys on every commit, so it needs the published package

## External Resources

- [Semantic Versioning](https://semver.org/)
- [NPM Publishing Best Practices](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [RubyGems Publishing Guide](https://guides.rubygems.org/publishing/)

## Implementation Steps

### 1. Update Release Documentation

**Purpose**: Modify the releasing guide to reflect the new two-phase process.

**File to Modify**: `docs/dev_guides/RELEASING.md`

**Changes Required**:
- Remove `make version-lock` from Step 1
- Add new Step 6: "Demo App Update" 
- Update the warning in Step 4 to clarify the process
- Add notes about the two-phase approach

### 2. Create New Makefile Target

**Purpose**: Create a demo-specific version lock command that only updates the demo app.

**File to Modify**: `Makefile`

**New Target**: `demo-version-lock`

**Functionality**:
- Only update `docs/demo/package.json` with the new NPM package version
- Run `yarn install` in the demo directory
- Update `docs/demo/Gemfile.lock` if needed

### 3. Modify Existing `version-lock` Target

**Purpose**: Update the existing `version-lock` to be more flexible about when it's run.

**File to Modify**: `Makefile`

**Changes Required**:
- Add conditional logic to check if NPM package exists in registry
- Provide clear error messages if package isn't available
- Option to skip NPM update if package not found

### 4. Create Post-Release Script

**Purpose**: Automate the demo app update process after package publication.

**File to Create**: `bin/update_demo_after_release`

**Functionality**:
- Run `make demo-version-lock`
- Create a commit with message "Update demo app to use version X.X.X"
- Optionally create a PR for the demo update

### 5. Update Version Management Scripts

**Purpose**: Ensure version update scripts work with the new process.

**File to Modify**: `bin/update_version`

**Changes Required**:
- Remove automatic `version-lock` execution
- Add informational message about the two-phase process
- Suggest next steps after version update

### 6. Create Release Checklist Template

**Purpose**: Provide a clear checklist for releases to avoid missing steps.

**File to Create**: `docs/templates/release_checklist.md`

**Content**:
- Pre-release checklist
- Phase 1: Package Release checklist  
- Phase 2: Demo Update checklist
- Post-release verification steps

## Detailed Implementation

### Phase 1: Package Release Process

1. **Version Update** (without demo lock)
   ```bash
   make version-bump  # or make version-set NEW_VERSION=X.X.X
   # Note: This will NOT run version-lock anymore
   ```

2. **Build and Test**
   ```bash
   make gem-build
   make npm-build
   ```

3. **Update Changelog**
   - Manual process or assisted by AI

4. **Commit and Create PR**
   ```bash
   git add .
   git commit -m "Release version X.X.X"
   # Create PR, get approval, merge
   ```

5. **Publish Packages**
   ```bash
   git tag vX.X.X
   git push origin vX.X.X
   make gem-publish
   make npm-publish
   ```

6. **Create GitHub Release**
   - Manual process through GitHub UI

### Phase 2: Demo App Update Process

1. **Update Demo App**
   ```bash
   make demo-version-lock
   ```

2. **Commit Demo Update**
   ```bash
   git add docs/demo/
   git commit -m "Update demo app to use version X.X.X"
   git push
   ```

3. **Verify Deployment**
   - Check that demo app deploys successfully
   - Verify Algolia indexing runs correctly

## File Changes Summary

### New Files
- `docs/plans/2025-09-release_process_improvement.md` (this file)
- `docs/templates/release_checklist.md`
- `bin/update_demo_after_release`

### Modified Files
- `docs/dev_guides/RELEASING.md`
- `Makefile`
- `bin/update_version`

## Benefits

1. **Eliminates Circular Dependency**: Packages are published before demo app tries to use them
2. **Clearer Process**: Two distinct phases make the process easier to understand
3. **Better Error Handling**: Clear messages when packages aren't available
4. **Automated Demo Updates**: Script to handle demo app updates consistently
5. **Maintains Auto-Deploy**: Demo app can still auto-deploy without breaking

## Risks and Mitigations

### Risk: Forgetting Phase 2
**Mitigation**: 
- Clear documentation and checklist
- Consider automation or reminders
- Make the demo update script as simple as possible

### Risk: Demo App Out of Sync
**Mitigation**:
- Clear versioning in demo app
- Automated checks to verify version alignment
- Documentation about version dependencies

### Risk: Breaking Changes in Process
**Mitigation**:
- Thorough testing of new scripts
- Gradual rollout with fallback options
- Clear rollback procedures

## Success Criteria

1. ✅ Can release packages without demo app dependency issues
2. ✅ Demo app successfully updates to new versions after publication
3. ✅ Process is documented and easy to follow
4. ✅ Auto-deployment continues to work correctly
5. ✅ No manual intervention required for routine releases

## Next Steps

1. Review and approve this plan
2. Implement changes in order of dependencies
3. Test the new process with a patch release
4. Update team documentation and training
5. Consider further automation opportunities
