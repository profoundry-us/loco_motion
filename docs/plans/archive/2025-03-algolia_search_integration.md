# Algolia Search Integration Plan

## Overview

This plan outlines the implementation of an Algolia search integration for the LocoMotion
documentation site. The integration will utilize the component information in
`lib/loco_motion/helpers.rb` to build a comprehensive search index that can be used with
an Algolia-powered search UI.

## External Resources

- [Algolia Ruby API Client](https://www.algolia.com/doc/api-client/ruby/getting-started/)
- [Algolia InstantSearch.js](https://www.algolia.com/doc/guides/building-search-ui/what-is-instantsearch/js/)
- [Algolia Rails Integration](https://www.algolia.com/doc/framework-integration/rails/)

## Implementation Steps

### 1. Setup Algolia Client

**Purpose**: Configure the Algolia client with appropriate credentials and settings.

**File to Create**: `lib/loco_motion/algolia/client.rb`

**Reference Files**:
- None specific, but follow standard Ruby service pattern

### 2. Create Component Indexer Service

**Purpose**: Extract and format component data from the LocoMotion helpers for Algolia indexing.

**File to Create**: `lib/loco_motion/algolia/component_indexer.rb`

**Reference Files**:
- `lib/loco_motion/helpers.rb` (for accessing component data)

### 3. Create Documentation Extractor

**Purpose**: Extract YARD documentation from the component files to enhance the search index.

**File to Create**: `lib/loco_motion/algolia/documentation_extractor.rb`

**Reference Files**:
- Component files in `app/components/` directory

### 4. Create Example Extractor

**Purpose**: Extract example usage from the demo app to include in search results.

**File to Create**: `lib/loco_motion/algolia/example_extractor.rb`

**Reference Files**:
- Example files in `docs/demo/app/views/examples/` directory

### 5. Create Search Record Builder

**Purpose**: Combine component data, documentation, and examples into search records.

**File to Create**: `lib/loco_motion/algolia/search_record_builder.rb`

**Reference Files**:
- Output from the previous extractors

### 6. Create Rake Task

**Purpose**: Provide command-line interface for building and uploading the Algolia index.

**File to Create**: `lib/tasks/algolia.rake`

**Reference Files**:
- Other rake tasks in the project

### 10. Update Configuration

**Purpose**: Add necessary configuration for Algolia integration.

**File to Create**: `config/initializers/algolia.rb`

**Reference Files**:
- None specific

### 11. Create Search Integration Tests

**Purpose**: Ensure the Algolia integration works correctly.

**File to Create**: `spec/lib/loco_motion/algolia/component_indexer_spec.rb`

**Reference Files**:
- Other spec files

## Implementation Details

### Rake Task Implementation

The rake task will provide the following functionality:

```ruby
# In lib/tasks/algolia.rake
namespace :loco do
  namespace :algolia do
    desc "Build and upload Algolia search index"
    task :index => :environment do
      # Initialize Algolia client
      # Build component records
      # Upload to Algolia
      # Output summary statistics
    end

    desc "Clear Algolia search index"
    task :clear => :environment do
      # Initialize Algolia client
      # Clear the index
    end
  end
end
```

### Component Data Structure

Each search record will include:

1. Component name and path
2. Component group and title
3. Documentation extracted from YARD
4. Example usage code
5. Example rendered output (as text)
6. Helper method names
7. Links to examples


## Next Steps After Implementation

1. Set up a GitHub Action to rebuild the index on changes to main branch
2. Consider expanding the index to include guide content
3. Add analytics tracking to monitor search usage
