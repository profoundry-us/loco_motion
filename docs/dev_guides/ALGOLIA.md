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

# Process a single file
make algolia-index ARGS="--file app/views/examples/daisy/actions/modals.html.haml"

# Process a single file with additional options
make algolia-index ARGS="--file app/views/examples/daisy/actions/modals.html.haml --output tmp/algolia/modals_index.json --skip-upload"

# Process all components with debug output
make algolia-index ARGS="--debug"

# Save output to a specific JSON file and skip uploading to Algolia
make algolia-index ARGS="--output tmp/algolia/my_components.json --skip-upload"

# Show help information
make algolia-index ARGS="--help"
```

**Available Options:**

| Option | Description |
| ------ | ----------- |
| `-f, --file PATH` | Process a specific file |
| `-d, --debug` | Enable debug output |
| `-o, --output PATH` | Save results to a JSON file |
| `-s, --skip-upload` | Skip uploading to Algolia |
| `-h, --help` | Display help message |

**Important Notes:**

1. File paths are relative to the `docs/demo` directory.
2. You can specify a file either as the first positional argument or using the `--file` option.
3. If no file path is provided, all components will be processed.
4. All records are collected and sent to Algolia in a single batch upload.
5. By default, JSON output is saved to `tmp/algolia/algolia_index.json` if no output path is specified.

If Algolia credentials are available, the data will be uploaded to Algolia.
Regardless of credentials, a JSON file will always be generated with the processed data.


### algolia-clear

This command allows you to clear an Algolia index. It requires confirmation
unless the `--force` flag is used.

```bash
# Clear the default index (with confirmation prompt)
make algolia-clear

# Clear the index without confirmation
make algolia-clear ARGS="--force"

# Clear a specific index
make algolia-clear ARGS="--index custom_index_name"

# Clear a specific index without confirmation and with debug output
make algolia-clear ARGS="--index custom_index_name --force --debug"

# Show help information
make algolia-clear ARGS="--help"
```

**Available Options:**

| Option | Description |
| ------ | ----------- |
| `-i, --index NAME` | Specify the index name to clear (default: 'loco_examples') |
| `-f, --force` | Skip confirmation prompt |
| `-d, --debug` | Enable debug output |
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
