# Convert Algolia Rake Tasks to Ruby Binaries Plan

## Overview

This plan outlines the conversion of the existing Algolia rake tasks to standalone Ruby
binaries. The current implementation relies on rake tasks which require loading the
Rails environment, adding overhead and complexity. By converting these tasks to dedicated
Ruby binaries, we'll simplify usage, improve performance, and provide a more direct
interface for developers.

## External Resources

- [Algolia Ruby API Client](https://www.algolia.com/doc/api-client/ruby/getting-started/)
- [Ruby OptionParser](https://ruby-doc.org/stdlib-2.7.1/libdoc/optparse/rdoc/OptionParser.html)

## Implementation Steps

### 1. Create the algolia_index Binary

**Purpose**: Create a binary that handles both single file parsing and full component indexing.

**File to Create**: `bin/algolia_index`

**Reference Files**:
- `bin/parse_haml`
- `lib/tasks/algolia.rake` (loco:algolia:index task)

### 2. Create the algolia_clear Binary

**Purpose**: Create a binary that clears the Algolia search index with confirmation.

**File to Create**: `bin/algolia_clear`

**Reference Files**:
- `lib/tasks/algolia.rake` (loco:algolia:clear task)

### 3. Update Documentation

**Purpose**: Document the new binaries and update any references to rake tasks.

**File to Edit**: `docs/dev_guides/ALGOLIA.md` (create if doesn't exist)

**Reference Files**:
- Other documentation files in `docs/dev_guides/`

### 4. Deprecate Rake Tasks

**Purpose**: Add deprecation warnings to the rake tasks to encourage use of the new binaries.

**File to Edit**: `lib/tasks/algolia.rake`

**Reference Files**:
- Current implementation in `lib/tasks/algolia.rake`

## Implementation Details

### algolia_index Binary Implementation

The `algolia_index` binary will provide the following functionality:

- Process a single HAML file if provided as an argument
- Process all components if no file is provided
- Check for Algolia credentials and upload data if available
- Always save results to a JSON file in the tmp directory
- Support debugging mode via `--debug` flag

```ruby
#!/usr/bin/env ruby
# Parse HAML files and index content to Algolia

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'optparse'
require 'loco_motion/algolia/haml_parser_service'
require 'loco_motion/algolia/algolia_import_service'
# ... (additional requires)

# Parse command line options
options = {debug: false}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: bin/algolia_index [options] [file_path]"
  # Define options
end
parser.parse!(ARGV)

# ... (implementation)
```

### algolia_clear Binary Implementation

The `algolia_clear` binary will provide the following functionality:

- Clear the Algolia index
- Require confirmation before proceeding unless a force flag is provided
- Support debugging mode via `--debug` flag

```ruby
#!/usr/bin/env ruby
# Clear the Algolia search index

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'optparse'
require 'loco_motion/algolia/client'

# Parse command line options
options = {debug: false, force: false}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: bin/algolia_clear [options]"
  # Define options
end
parser.parse!(ARGV)

# ... (implementation)
```

## Advantages of This Approach

1. **Simplified Usage**: Developers can run the binaries directly without needing to understand rake
2. **Better Error Handling**: Direct error reporting from the binary without rake interference
3. **More Flexibility**: Easier to extend with additional command-line options
4. **Consistent Interface**: Same interface for both single file and multi-component processing
5. **Reduced Dependency**: Less dependency on Rails environment for simple operations
