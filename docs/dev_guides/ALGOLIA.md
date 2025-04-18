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
It can process either a single component or all components.

```bash
# Process all components
make algolia-index

# Process a specific component
make algolia-index ARGS="--component Daisy::Actions::Modal"

# Process a specific component and save output to a specific JSON file
make algolia-index ARGS="--component Daisy::Actions::Modal --output tmp/algolia/modals_index.json"

# Skip uploading to Algolia and only save the output
make algolia-index ARGS="--skip-upload"

# Save output to a specific JSON file and skip uploading to Algolia
make algolia-index ARGS="--output tmp/algolia/my_components.json --skip-upload"

# Show help information
make algolia-index ARGS="--help"
```

**Available Options:**

| Option | Description |
| ------ | ----------- |
| `-c, --component NAME` | Process a specific component (e.g. 'Daisy::DataDisplay::ChatBubble') |
| `-o, --output PATH` | Save results to a JSON file |
| `-s, --skip-upload` | Skip uploading to Algolia |
| `-h, --help` | Display help message |

**Important Notes:**

1. If no component is specified, all components will be processed.
2. All records are collected and sent to Algolia in a single batch upload.
3. By default, JSON output is saved to `tmp/algolia/algolia_index.json` if no output path is specified.

If Algolia credentials are available, the data will be uploaded to Algolia.
Regardless of credentials, a JSON file will always be generated with the processed data.

## Automatic Indexing on Deployment

The Algolia indexing process runs automatically during application deployment on
Heroku through the following mechanism:

1. The `Procfile` includes a `release` phase command that runs the
   `bin/reindex_algolia` script.
2. This script runs both the `algolia:clear` and `algolia:index` rake tasks.
3. The environment variable `ALGOLIA_ENV` determines which index is used, keeping
   staging and production environments separate.

This means that every time the demo application is deployed, the Algolia index
will be automatically refreshed with the latest component documentation.

### Environment Variables

The following environment variables control the Algolia integration:

| Variable | Description |
| -------- | ----------- |
| `ALGOLIA_APPLICATION_ID` | Your Algolia application ID |
| `ALGOLIA_API_KEY` | Your Algolia API key with write permissions |
| `ALGOLIA_ENV` | Environment name used in the index name (e.g., `production`, `staging`) |

### algolia-clear

This command allows you to clear an Algolia index. It requires confirmation
unless the `--force` flag is used.

```bash
# Clear a requested index (required)
make algolia-clear ARGS="--index index_name"

# Clear a specific index without confirmation
make algolia-clear ARGS="--index custom_index_name --force"

# Show help information
make algolia-clear ARGS="--help"
```

**Available Options:**

| Option | Description |
| ------ | ----------- |
| `-i, --index NAME` | Specify the index name to clear (*required) |
| `-f, --force` | Skip confirmation prompt |
| `-h, --help` | Display help message |


## Running Rake Tasks Directly

While the Makefile commands are the recommended approach as they ensure all operations
run in the proper Docker container, you can also run the Rake tasks directly in the demo
application:

```bash
# Run the algolia:index task directly in the demo container
docker compose exec -it demo bundle exec rake algolia:index

# Run with additional arguments
docker compose exec -it demo bundle exec rake algolia:index ARGS="--debug --output tmp/algolia/components.json"

# Clear the index directly
docker compose exec -it demo bundle exec rake algolia:clear
```

## Implementation Details

The Algolia integration is implemented as Rake tasks in the demo Rails application. The
tasks are located in `docs/demo/lib/tasks/algolia.rake` and use the services defined in
`docs/demo/app/services/algolia/`.

The main services are:

- `Algolia::HamlParserService` - Parses HAML files to extract documentation and examples
- `Algolia::AlgoliaImportService` - Handles uploading data to Algolia
- `Algolia::JsonExportService` - Handles exporting data to JSON files

The workflow is as follows:

1. The `algolia:index` rake task parses the specified HAML files
2. Records are extracted from each file and collected into a single batch
3. If Algolia credentials are available and `--skip-upload` is not specified, all records are uploaded in a single batch
4. Records are also saved to a JSON file (either at the specified path or the default tmp/algolia directory)
