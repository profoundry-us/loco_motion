<!-- omit from toc -->
# Releasing New Versions

This guide will walk you through the process of releasing a new version of
LocoMotion.

- [Preparation](#preparation)
- [Step 1 - Version Update](#step-1---version-update)
  - [Using Makefile Commands (Recommended)](#using-makefile-commands-recommended)
  - [Using the Script Directly](#using-the-script-directly)
- [Step 2 - Building and Testing](#step-2---building-and-testing)
- [Step 3 - Update Changelog](#step-3---update-changelog)
- [Step 4 - Publishing](#step-4---publishing)
  - [Ruby Gem](#ruby-gem)
  - [NPM Package](#npm-package)
- [Step 5 - GitHub Release](#step-5---github-release)

## Preparation

Before releasing a new version, ensure:

1. All tests are passing locally:

   ```bash
   make loco-test
   ```

2. All documentation is up to date and properly formatted.
3. All changes are committed and pushed to the main branch.
4. You have the necessary credentials for both RubyGems.org and NPM.

## Step 1 - Version Update

Update the version across all files using one of the following methods:

### Using Makefile Commands (Recommended)

```bash
# Interactive mode - will prompt for new version
make version-bump

# Specify version directly
make version-set NEW_VERSION=1.0.0
```

### Using the Script Directly

```bash
bin/update_version         # Interactive mode
# OR
bin/update_version 1.0.0   # Specify version directly
```

This will automatically update:

- `lib/loco_motion/version.rb` (primary source of truth)
- `package.json`
- `docs/demo/package.json` (updates the dependency on `@profoundry-us/loco_motion`)

After updating the version, you should update both the loco and demo app bundles to ensure they're using the new version:

```bash
# Update the loco container's bundle
make loco-update

# Update the demo app's bundle
make demo-update
```

This ensures that both the loco container and demo app are using the latest version of the gem from the vendor directory.

## Step 2 - Building and Testing

1. Build the Ruby gem:

   ```bash
   make gem-build
   ```

   This will create a new gem file in the `builds/rubygems` directory with the
   current version number.

2. Verify the gem build looks correct by checking the contents of
   `builds/rubygems/loco_motion-rails-[VERSION].gem`.

3. Build the NPM package:

   ```bash
   make npm-build
   ```

   This will create a new tarball in the `builds/npm` directory.

4. Verify the NPM package looks correct by checking the contents of
   `builds/npm/profoundry-us-loco_motion-[VERSION].tgz`.

## Step 3 - Update Changelog

Once you have verified that everything is built and running correctly, you
should update the `CHANGELOG.md` file with all of the relevant changes since the
last release. You can ask Windsurf to do this. We recommend the following
prompt:

```
We need to update the CHANGELOG with the 0.4.0 changes.

Please review the existing changelog for the proper format / concept and utilize
git commands to build a relevant changelog update.
```

## Step 4 - Publishing

Before publishing the packages, ensure your changes are merged to the main
branch:

1. Commit any changes to the Gemfile, Gemfile.lock, CHANGELOG, etc
2. Create a pull request with your changes
3. Get the pull request reviewed and approved
4. Merge the pull request into main
5. Pull the latest main branch locally:

   ```bash
   git checkout main
   git pull
   ```

### Ruby Gem

1. Create and push a version tag:

   ```bash
   git tag v$(make version)
   git push origin v$(make version)
   ```

2. Publish the gem to RubyGems.org:

   ```bash
   make gem-publish
   ```

3. Verify the gem is available on [RubyGems][rubygems].

### NPM Package

1. Ensure you're on the main branch with the latest changes.

2. Publish the NPM package:

   ```bash
   make npm-publish
   ```

3. Verify the package is available on [npmjs.com][npm].

## Step 5 - GitHub Release

After both packages are published, create a new release on GitHub:

1. Go to the [releases page][github-releases]
2. Click "Draft a new release"
3. Select the version tag you created
4. Add release notes describing the changes (GitHub has an AI tool to do this)
5. Publish the release

[rubygems]: https://rubygems.org/gems/loco_motion-rails
[npm]: https://www.npmjs.com/package/@profoundry/loco_motion
[github-releases]: https://github.com/profoundry-us/loco_motion/releases
