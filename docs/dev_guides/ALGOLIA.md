# Algolia Integration Guide

This guide describes how to use the Algolia integration for the LocoMotion
component library. The integration allows you to index component documentation
and examples for search functionality.


## Overview

The Algolia integration provides two main features:

1. Indexing component documentation and examples to Algolia
2. Parsing individual HAML files for content extraction

These operations can be performed using dedicated binaries provided in the
repository.


## Environment Variables

To upload data to Algolia, you need to set the following environment variables:

- `ALGOLIA_APPLICATION_ID`: Your Algolia application ID
- `ALGOLIA_API_KEY`: Your Algolia API key with write access
- `DEBUG`: Set to 'true' to enable verbose debug output (optional)

If these credentials are not provided, the indexing operation will still
generate a JSON file locally, but data won't be uploaded to Algolia.


## Available Binaries

### algolia_index

This binary allows you to index component documentation and examples to Algolia.
It can process either a single HAML file or all components.

```bash
# Process all components
bin/algolia_index

# Process a single HAML file
bin/algolia_index path/to/file.html.haml

# Process all components with debug output
bin/algolia_index --debug

# Show help information
bin/algolia_index --help
```

If Algolia credentials are available, the data will be uploaded to Algolia.
Regardless of credentials, a JSON file will always be generated in the `tmp`
directory with the processed data.


### algolia_clear

This binary allows you to clear the Algolia index. It requires confirmation
unless the `--force` flag is used.

```bash
# Clear the index (with confirmation prompt)
bin/algolia_clear

# Clear the index without confirmation
bin/algolia_clear --force

# Show help information
bin/algolia_clear --help
```


## Usage with Rails

When running outside of a Rails environment, these binaries might need the Rails
environment for accessing certain functionality. In those cases, you can run
them through Rails:

```bash
# Run with Rails environment
RAILS_ENV=development bin/rails runner bin/algolia_index
```


## Legacy Rake Tasks (Deprecated)

The following rake tasks are deprecated and will be removed in a future version:

- `loco:algolia:index`: Use `bin/algolia_index` instead
- `loco:algolia:clear`: Use `bin/algolia_clear` instead
- `loco:algolia:parse_file`: Use `bin/algolia_index <file_path>` instead
