# Algolia Integration Guide

This guide describes how to use the Algolia integration for the LocoMotion
component library. The integration allows you to index component documentation
and examples for search functionality.


## Overview

The Algolia integration provides two main features:

1. Indexing component documentation and examples to Algolia
2. Parsing individual HAML files for content extraction

These operations can be performed using dedicated commands provided in the
repository.


## Environment Variables

To upload data to Algolia, you need to set the following environment variables:

- `ALGOLIA_APPLICATION_ID`: Your Algolia application ID
- `ALGOLIA_API_KEY`: Your Algolia API key with write access
- `DEBUG`: Set to 'true' to enable verbose debug output (optional)

If these credentials are not provided, the indexing operation will still
generate a JSON file locally, but data won't be uploaded to Algolia.


## Available Commands

### algolia-index

This command allows you to index component documentation and examples to Algolia.
It can process either a single HAML file or all components.

```bash
# Process all components
make algolia-index

# Process a single HAML file
make algolia-index ARGS="path/to/file.html.haml"

# Process all components with debug output
make algolia-index ARGS="--debug"

# Show help information
make algolia-index ARGS="--help"
```

If Algolia credentials are available, the data will be uploaded to Algolia.
Regardless of credentials, a JSON file will always be generated in the `tmp`
directory with the processed data.


### algolia-clear

This command allows you to clear the Algolia index. It requires confirmation
unless the `--force` flag is used.

```bash
# Clear the index (with confirmation prompt)
make algolia-clear

# Clear the index without confirmation
make algolia-clear ARGS="--force"

# Show help information
make algolia-clear ARGS="--help"
```


## Usage with Rails

When running outside of a Docker environment, these commands need to be run through
Rails. In those cases, you can run them directly:

```bash
# Run with Rails environment
RAILS_ENV=development bin/rails runner bin/algolia_index
```

However, it's generally recommended to use the make commands which will run the
binaries in the proper Docker container.
