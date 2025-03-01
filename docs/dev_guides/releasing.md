<!-- omit from toc -->
# Releasing New Versions

This guide will walk you through the process of releasing a new version of
LocoMotion.

- [Preparation](#preparation)
- [Version Update](#version-update)
- [Building and Testing](#building-and-testing)
- [Publishing](#publishing)
  - [Ruby Gem](#ruby-gem)
  - [NPM Package](#npm-package)

## Preparation

Before releasing a new version, ensure:

1. All tests are passing locally:

   ```bash
   make loco-test
   ```

2. All documentation is up to date and properly formatted.
3. All changes are committed and pushed to the main branch.
4. You have the necessary credentials for both RubyGems.org and NPM.

## Version Update

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
bin/update_version          # Interactive mode
# OR
bin/update_version 1.0.0   # Specify version directly
```

This will automatically update:

- `lib/loco_motion/version.rb` (primary source of truth)
- `package.json`

## Building and Testing

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

## Publishing

Before publishing, ensure your changes are merged to the main branch:

1. Create a pull request with your changes
2. Get the pull request reviewed and approved
3. Merge the pull request into main
4. Pull the latest main branch locally:

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

After both packages are published, create a new release on GitHub:

1. Go to the [releases page][github-releases]
2. Click "Draft a new release"
3. Select the version tag you created
4. Add release notes describing the changes
5. Publish the release

[rubygems]: https://rubygems.org/gems/loco_motion-rails
[npm]: https://www.npmjs.com/package/@profoundry/loco_motion
[github-releases]: https://github.com/profoundry-us/loco_motion/releases
