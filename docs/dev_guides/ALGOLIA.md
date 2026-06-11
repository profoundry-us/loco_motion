# Algolia Integration Guide

This guide describes how to use the Algolia integration for the LocoMotion
component library. The integration allows you to index component documentation
and examples for search functionality.


## Overview

The Algolia integration provides three main features:

1. Indexing component documentation and examples to Algolia
2. Parsing individual HAML files for content extraction
3. Generating `llms.txt` documentation for LLM consumption

These operations can be performed using dedicated Rake tasks provided in the
demo application.


## Environment Variables

The integration uses two separate API keys with different permission levels:

- `ALGOLIA_APPLICATION_ID`: Your Algolia application ID
- `ALGOLIA_API_KEY`: A **write-capable** key (`addObject`, `deleteObject`,
  etc.) used only by the server-side indexing rake tasks and the Heroku
  release phase. This key must **never** be exposed to the browser.
- `ALGOLIA_SEARCH_API_KEY`: A **search-only** key injected into every demo
  page (via `algolia_credentials_tag`) to power the frontend search UI. Create
  it in the Algolia dashboard with only the `search` ACL.
- `DEBUG`: Set to 'true' to enable verbose debug output (optional)

Set all of these in the demo application's `.env.local` file for local
development, and in the Heroku config vars for deployed environments.

If the write credentials are not provided, the indexing operation will still
generate a JSON file locally, but data won't be uploaded to Algolia. If the
search key is not provided, the frontend search box won't return results.


## Available Commands

### algolia-index

This command allows you to index component documentation and examples to
Algolia. It can process either a single component or all components.

```bash
# Process all components
just algolia-index

# Process a specific component
just algolia-index --component Daisy::Actions::Modal

# Process a specific component and save output to a specific JSON file
just algolia-index --component Daisy::Actions::Modal --output tmp/algolia/modals_index.json

# Skip uploading to Algolia and only save the output
just algolia-index --skip-upload

# Save output to a specific JSON file and skip uploading to Algolia
just algolia-index --output tmp/algolia/my_components.json --skip-upload

# Show help information
just algolia-index --help
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
3. By default, JSON output is saved to `tmp/algolia/algolia_index.json` if no
   output path is specified.

If Algolia credentials are available, the data will be uploaded to Algolia.
Regardless of credentials, a JSON file will always be generated with the
processed data.

## Automatic Indexing on Deployment

The Algolia indexing process runs automatically during application deployment on
Heroku through the following mechanism:

1. The `Procfile` includes a `release` phase command that runs the
   `bin/reindex_algolia` script.
2. This script runs both the `algolia:clear` and `algolia:index` rake tasks.
3. The environment variable `ALGOLIA_ENV` determines which index is used,
   keeping staging and production environments separate.

This means that every time the demo application is deployed, the Algolia index
will be automatically refreshed with the latest component documentation.

### Environment Variables

The following environment variables control the Algolia integration:

| Variable | Description |
| -------- | ----------- |
| `ALGOLIA_APPLICATION_ID` | Your Algolia application ID |
| `ALGOLIA_API_KEY` | Write-capable API key, server-side indexing only — never sent to the browser |
| `ALGOLIA_SEARCH_API_KEY` | Search-only API key exposed to the browser for the frontend search UI |
| `ALGOLIA_ENV` | Environment name used in the index name (e.g., `production`, `staging`) |

### algolia-clear

This command allows you to clear an Algolia index. It requires confirmation
unless the `--force` flag is used.

```bash
# Clear a requested index (required)
just algolia-clear --index index_name

# Clear a specific index without confirmation
just algolia-clear --index custom_index_name --force

# Show help information
just algolia-clear --help
```

**Available Options:**

| Option | Description |
| ------ | ----------- |
| `-i, --index NAME` | Specify the index name to clear (*required) |
| `-f, --force` | Skip confirmation prompt |
| `-h, --help` | Display help message |


### llm

This command generates `llms.txt` and `llms-full.txt` files containing all
component documentation in a format optimized for Large Language Model
consumption.

```bash
# Generate llms.txt and llms-full.txt for all components (default output: public/)
just llm

# Generate for a specific component
just llm --component Daisy::Actions::Modal

# Generate to a custom output directory
just llm --output custom/path/

# Show help information
just llm --help
```

**Available Options:**

| Option | Description |
| ------ | ----------- |
| `-c, --component NAME` | Process a specific component (e.g. 'Daisy::DataDisplay::ChatBubble') |
| `-o, --output DIR` | Save results to the specified directory (default: public/) |
| `-h, --help` | Display help message |

**Output Format:**

The generated files include:

1. `llms.txt` — A top-level index of all components with API and example URLs.
2. `llms-full.txt` — Detailed sections for each component, including:
   - Component metadata (group, title, URLs)
   - Description
   - Helper method names
   - All examples with code and descriptions

**Output Location:**

By default, the files are generated in the demo app's `public` directory in both
versioned and versionless forms:

1. **Versioned files**: `public/llms-v{VERSION}.txt` and
   `public/llms-full-v{VERSION}.txt` (e.g., `llms-v0.5.1.txt`).
2. **Versionless files**: `public/llms.txt` and `public/llms-full.txt` (always
   point to the latest version).

Both forms are accessible via HTTP on the demo site:

- `https://your-demo-site.com/llms.txt` (latest index)
- `https://your-demo-site.com/llms-full.txt` (latest full docs)
- `https://your-demo-site.com/llms-v0.5.1.txt` (specific version, index)
- `https://your-demo-site.com/llms-full-v0.5.1.txt` (specific version, full)

**Required Hand-Maintained Input:**

The `llms-full.txt` output includes a "Common Usage Patterns" section that is
read from `docs/demo/data/usage_patterns.md`
(`Rails.root.join('data', 'usage_patterns.md')` from inside the demo app). This
file is **hand-maintained** and is a required input for high-quality LLM output
— it is not generated from the component registry. When you add new usage
guidance or change recommended patterns, update this file before regenerating
the `llms` files. If the file is missing, the section is simply omitted.

**Important Notes:**

1. The output is plain text formatted for optimal LLM parsing.
2. Component ordering is deterministic based on the registry.
3. No Algolia credentials are required for this operation.
4. Code examples are enclosed in triple backticks with language hints.
5. The versioned filenames ensure proper caching and version tracking.

## Running Rake Tasks Directly

While the justfile commands are the recommended approach as they ensure all
operations run in the proper Docker container, you can also run the Rake tasks
directly in the demo application:

```bash
# Run the algolia:index task directly in the demo container
docker compose exec -it demo bundle exec rake algolia:index

# Run with additional arguments
docker compose exec -it demo bundle exec rake algolia:index ARGS="--debug --output tmp/algolia/components.json"

# Clear the index directly
docker compose exec -it demo bundle exec rake algolia:clear

# Generate llms.txt and llms-full.txt directly
docker compose exec -it demo bundle exec rake algolia:llm
```

## Implementation Details

The Algolia integration is implemented as Rake tasks in the demo Rails
application. The tasks are located in `docs/demo/lib/tasks/algolia.rake` and use
the services defined in `docs/demo/app/services/algolia/`.

The main services are:

- `Algolia::HamlParserService` - Parses HAML files to extract documentation and
  examples.
- `Algolia::AlgoliaImportService` - Handles uploading data to Algolia.
- `Algolia::JsonExportService` - Handles exporting data to JSON files.
- `Algolia::RecordConverterService` - Converts parsed data to Algolia search
  records.
- `Algolia::LlmAggregationService` - Aggregates component data for the `llms`
  export.
- `Algolia::LlmTextExportService` - Formats and exports data to the `llms.txt`
  and `llms-full.txt` formats.

The workflow is as follows:

### For Algolia Indexing

1. The `algolia:index` rake task parses the specified HAML files.
2. Records are extracted from each file and collected into a single batch.
3. If Algolia credentials are available and `--skip-upload` is not specified,
   all records are uploaded in a single batch.
4. Records are also saved to a JSON file (either at the specified path or the
   default `tmp/algolia` directory).

### For llms.txt Generation

1. The `algolia:llm` rake task uses `Algolia::LlmAggregationService` to collect
   component data.
2. `Algolia::HamlParserService` extracts documentation from each component's
   example file.
3. `Algolia::LlmTextExportService` formats the aggregated data into plain text,
   pulling in the hand-maintained `docs/demo/data/usage_patterns.md` for the
   "Common Usage Patterns" section.
4. Output is written to the specified directory (default: the demo app's
   `public/` directory) as both `llms.txt`/`llms-full.txt` and their versioned
   counterparts.
