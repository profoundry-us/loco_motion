# Algolia Integration Guide

This guide describes how to use the Algolia integration for the LocoMotion
component library. The integration allows you to index component documentation
and examples for search functionality.


## Overview

The Algolia integration provides two main features:

1. Indexing component documentation and examples to Algolia
2. Parsing individual HAML files for content extraction

These operations can be performed using dedicated Rake tasks provided in the
demo application.


## Environment Variables

To upload data to Algolia, you need to set the following environment variables in the
demo application's `.env.local` file:

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

# Save output to a specific JSON file and skip uploading to Algolia
make algolia-index ARGS="--output tmp/my_components.json --skip-upload"

# Show help information
make algolia-index ARGS="--help"
```

If Algolia credentials are available, the data will be uploaded to Algolia.
Regardless of credentials, a JSON file will always be generated in the `tmp`
directory with the processed data if the `--output` option is specified.


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


## Running Rake Tasks Directly

While the Makefile commands are the recommended approach as they ensure all operations
run in the proper Docker container, you can also run the Rake tasks directly in the demo
application:

```bash
# Run the algolia:index task directly in the demo container
docker compose exec -it demo bundle exec rake algolia:index

# Run with additional arguments
docker compose exec -it demo bundle exec rake algolia:index ARGS="--debug --output tmp/components.json"

# Clear the index directly
docker compose exec -it demo bundle exec rake algolia:clear
```

## Implementation Details

The Algolia integration is implemented as Rake tasks in the demo Rails application. The
tasks are located in `docs/demo/lib/tasks/algolia.rake` and use the services defined in
`docs/demo/app/services/algolia/`.

The main services are:

- `Algolia::Index` - Handles Algolia client configuration and index operations
- `Algolia::ComponentIndexer` - Builds search records from component documentation
- `Algolia::HamlParserService` - Parses HAML files to extract documentation
- `Algolia::SearchRecordBuilder` - Enriches component data with examples
- `Algolia::AlgoliaImportService` - Handles uploading data to Algolia or saving to a file
