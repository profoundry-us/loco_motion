<!-- omit from toc -->
# Releasing New Versions

This guide will walk you through the process of releasing a new version of
LocoMotion.

- [Preparation](#preparation)
- [Release Checklist](#release-checklist)
- [Step 1 - Version Update](#step-1---version-update)
  - [Using Makefile Commands (Recommended)](#using-makefile-commands-recommended)
  - [Using the Script Directly](#using-the-script-directly)
- [Step 2 - Update Changelog](#step-2---update-changelog)
- [Step 3 - Building and Testing](#step-3---building-and-testing)
- [Step 4 - Publishing](#step-4---publishing)
  - [Ruby Gem](#ruby-gem)
  - [NPM Package](#npm-package)
- [Step 5 - GitHub Release](#step-5---github-release)
- [Step 6 - Demo App Update](#step-6---demo-app-update)
- [Step 7 - Algolia Indexing](#step-7---algolia-indexing)
- [Step 8 - LLM Documentation Generation](#step-8---llm-documentation-generation)

## Preparation

Before releasing a new version, ensure:

1. All tests are passing locally:

   ```bash
   make loco-test
   ```

2. All documentation is up to date and properly formatted.
3. All changes are committed and pushed to the main branch.
4. You have the necessary credentials for both RubyGems.org and NPM.

## Release Checklist

A personalized release checklist is automatically created when you run the
version update commands. The checklist will be created at:

```
docs/checklists/release-checklist-v[VERSION].md
```

The checklist includes all the steps from this guide in a checkable format,
plus troubleshooting tips and verification steps. You can check off items as
you complete them and keep the file as a record of the release process.

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

After updating the version, you can safely update the loco container to use the
new gem version:

```bash
# Update the loco container to use the new gem version (safe to run anytime)
make loco-version-lock
```

**Important**: Do NOT run `make demo-version-lock` at this stage, as it will fail
because the NPM package hasn't been published yet. The demo app will be updated
in a separate step after package publication.

> [!NOTE]
> The release process uses a two-phase approach to avoid circular dependencies:
> 1. **Phase 1**: Release packages (loco gem / package can be updated anytime)
> 2. **Phase 2**: Update demo app after NPM package is published

## Step 2 - Update Changelog

Update the `CHANGELOG.md` file with all of the relevant changes since the
last release. You can ask Windsurf to do this. We recommend the following
prompt:

```
We need to update the CHANGELOG with the 0.4.0 changes.

Please review the existing changelog for the proper format / concept and utilize
git commands to build a relevant changelog update.
```

## Step 3 - Building and Testing

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

## Step 4 - Publishing

> [!IMPORTANT]
> This step publishes the packages to their respective registries. The demo app
> will be updated in Step 6 after publication to avoid circular dependencies.

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

## Step 6 - Demo App Update

After both packages are published, update the demo app to use the new versions:

1. **Run the post-release script**:

   ```bash
   bin/update_demo_after_release
   ```

   This script will:
   - Check that you're on the main branch
   - Pull the latest changes
   - Run `make demo-version-lock` to update demo dependencies
   - Commit and push the changes

2. **Manual alternative** (if you prefer more control):

   ```bash
   # Update demo app dependencies
   make demo-version-lock

   # Commit the changes
   git add docs/demo/
   git commit -m "Update demo app to use version X.X.X"
   git push
   ```

3. **Verify the deployment**:
   - Monitor your hosting platform for successful deployment
   - Check that the demo app loads correctly
   - Verify the version number is displayed correctly

> [!NOTE]
> The demo app auto-deploys on every commit, so this step creates a separate
> commit after the packages are published to avoid circular dependencies.

## Step 7 - Algolia Indexing

When the demo application is deployed to Heroku after a new release, the Algolia
indexing process will run automatically to update the component documentation
search index.

1. The indexing process runs as part of the Heroku release phase.

2. Each environment (staging, production) uses a separate index determined by
   the `ALGOLIA_ENV` environment variable.

3. The index includes the version number, so each version of LocoMotion has its
   own search index.

If you need to manually trigger the reindexing process, you can run:

```bash
heroku run bin/reindex_algolia -a your-app-name
```

Or you can alter your `env.local` file to set the `ALGOLIA_ENV` variable to the
environment you want to use.

## Step 8 - LLM Documentation Generation

After the demo app is deployed and Algolia indexing is complete, generate the
LLM-friendly documentation files:

1. **Generate LLM documentation**:

   ```bash
   make llm
   ```

   This will:
   - Generate comprehensive LLM.txt files with all component documentation
   - Create both versioned (`LLM-vX.X.X.txt`) and versionless (`LLM.txt`) copies
   - Include usage patterns, component examples, and helper method documentation
   - Place files in the demo public directory for HTTP access

2. **Verify the generation**:

   ```bash
   # Check that files were generated
   ls -la docs/demo/public/LLM*.txt

   # Verify content quality
   docker compose exec -it demo bundle exec rake algolia:llm
   ```

3. **Commit the generated files**:

   ```bash
   git add docs/demo/public/LLM*.txt
   git commit -m "Generate LLM documentation for version X.X.X"
   git push
   ```

The LLM documentation is used by AI assistants to provide better code
generation and support for LocoMotion components.

See the [Algolia Integration Guide](ALGOLIA.md) for more details on how the
Algolia integration works.

[rubygems]: https://rubygems.org/gems/loco_motion-rails
[npm]: https://www.npmjs.com/package/@profoundry/loco_motion
[github-releases]: https://github.com/profoundry-us/loco_motion/releases
