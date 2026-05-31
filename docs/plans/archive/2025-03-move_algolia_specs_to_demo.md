# Moving Algolia Specs to Demo App

This plan outlines the steps needed to move the Algolia-related specs from the main
Loco Motion repository to the demo app where the implementation files now live.

## 1. Set Up Spec Directory Structure in Demo App

First, we need to create the proper spec directory structure in the demo app:

```bash
mkdir -p /Users/topherfangio/Development/profoundry/loco_motion/docs/demo/spec/services/algolia
mkdir -p /Users/topherfangio/Development/profoundry/loco_motion/docs/demo/spec/support
```

## 2. Create Spec Helper Files

We'll need to set up the basic spec configuration files:

```bash
# Create spec_helper.rb
touch /Users/topherfangio/Development/profoundry/loco_motion/docs/demo/spec/spec_helper.rb

# Create rails_helper.rb
touch /Users/topherfangio/Development/profoundry/loco_motion/docs/demo/spec/rails_helper.rb
```

## 3. Update Spec Files

We'll need to move and update each spec file:

### For algolia_import_service_spec.rb:

- Copy from: `/Users/topherfangio/Development/profoundry/loco_motion/spec/lib/loco_motion/algolia/algolia_import_service_spec.rb`
- To: `/Users/topherfangio/Development/profoundry/loco_motion/docs/demo/spec/services/algolia/algolia_import_service_spec.rb`
- Update namespaces from `LocoMotion::Algolia::AlgoliaImportService` to `Algolia::AlgoliaImportService`
- Update require statements from `require 'loco_motion/algolia/algolia_import_service'` to `require 'rails_helper'`

### For component_indexer_spec.rb:

- Copy from: `/Users/topherfangio/Development/profoundry/loco_motion/spec/lib/loco_motion/algolia/component_indexer_spec.rb`
- To: `/Users/topherfangio/Development/profoundry/loco_motion/docs/demo/spec/services/algolia/component_indexer_spec.rb`
- Update namespaces from `LocoMotion::Algolia::ComponentIndexer` to `Algolia::ComponentIndexer`
- Update require statements from `require 'loco_motion/algolia/component_indexer'` to `require 'rails_helper'`

### For haml_parser_service_spec.rb:

- Copy from: `/Users/topherfangio/Development/profoundry/loco_motion/spec/lib/loco_motion/algolia/haml_parser_service_spec.rb`
- To: `/Users/topherfangio/Development/profoundry/loco_motion/docs/demo/spec/services/algolia/haml_parser_service_spec.rb`
- Update namespaces from `LocoMotion::Algolia::HamlParserService` to `Algolia::HamlParserService`
- Update require statements from `require 'loco_motion/algolia/haml_parser_service'` to `require 'rails_helper'`

## 4. Update Gemfile to Add RSpec

Make sure the demo app's Gemfile includes RSpec in the development and test groups:

```ruby
group :development, :test do
  gem 'rspec-rails'
end
```

## 5. Initialize RSpec in the Demo App

Run the following commands:

```bash
cd /Users/topherfangio/Development/profoundry/loco_motion/docs/demo
bundle exec rails generate rspec:install
```

## 6. Remove Old Spec Files

After confirming the relocated specs work, we can remove the old specs:

```bash
rm -rf /Users/topherfangio/Development/profoundry/loco_motion/spec/lib/loco_motion/algolia
```

## 7. Update Main RSpec Configuration

Update the main repo's RSpec configuration to exclude any tests related to the moved
Algolia services:

Edit `/Users/topherfangio/Development/profoundry/loco_motion/spec/spec_helper.rb` to
exclude the old specs if they haven't been physically removed yet.

## 8. Run Tests in Demo App

Run the tests in the demo app to confirm everything works:

```bash
cd /Users/topherfangio/Development/profoundry/loco_motion/docs/demo
bundle exec rspec spec/services/algolia
```

## 9. Add Demo-Specific Spec Configurations

Add any demo-specific test configurations needed for the Algolia specs in the demo
app's test setup.

This plan ensures a clean migration of the Algolia specs to their new home in the
demo app, where they can properly test the implementations that were moved there.
