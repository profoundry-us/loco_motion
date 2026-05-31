# Generate LLM.txt From Algolia Pipeline Plan

**Status**: ✅ Implemented (2025-09-29)

## Overview

We will repurpose the existing Algolia indexing pipeline in the demo app to build a high-signal `LLM.txt` file that helps LLMs understand how to use LocoMotion. Instead of producing per-record JSON for Algolia, we will aggregate the same parsed component and example data into a single, readable text artifact optimized for LLM consumption.

This plan leverages the current services under `docs/demo/app/services/algolia/` and the rake workflow in `docs/demo/lib/tasks/algolia.rake`, adding a small formatter/exporter that produces the final `LLM.txt`.

## Goals

- Produce a single, deterministic text file with clear sections per component and example.
- Reuse parsing and component selection logic to avoid drift (same sources as Algolia pipeline).
- Keep output stable across releases and easy to diff in PRs.
- Make generation callable locally and in CI (and optionally on deploy).

## Non-Goals

- Changing the existing Algolia JSON export or upload behavior.
- Introducing new doc sources beyond what the Algolia pipeline already extracts.

## Content Sources

- `Algolia::HamlParserService` for `title`, `description`, and per-example `title`, `description`, `code` from example HAML files under `docs/demo/app/views/examples/...`.
- `LocoMotion::COMPONENTS` registry for the list of components and their example mappings.
- `LocoMotion::Helpers.component_example_path(component_name)` for stable example URLs.

## Output

- Default path: `docs/demo/public/LLM-v{VERSION}.txt` (served via HTTP on demo site). A versionless copy at `public/LLM.txt` always points to the latest version. Allow overriding via CLI flag.
- UTF-8 plain text.
- Deterministic component ordering (same as Algolia task: iterate `LocoMotion::COMPONENTS.keys` and index order).
- Version included in filename for proper caching and version tracking.

## Proposed LLM.txt Structure

### Top-level Component Index

Start with an overview of all available components:

```
# LocoMotion Component Library

This file provides comprehensive documentation for all LocoMotion components.

## Available Components

{For each component in order:}
- **{FullyQualifiedName}** ({Section}): {Short description from title/description}
  API: {API URL}
  Examples: {Examples URL}

---

## Component Details
```

### Per-Component Sections

For each component:

```
=== Component: {FullyQualifiedName}
Group: {SectionIfAny}
Title: {Parsed Title}
API URL: {API Documentation URL}
Examples URL: {Component Examples URL}
File: {Example HAML Path}

Description:
{Parsed description}

Helpers:
- {helper_method_names_if_available_or_placeholder}

Examples:
-- Example: {Example Title}
Description:
{example description}

Code (HAML):
```
{example code}
```
URL: {url#anchor}

[repeat for each example]

---
```

Notes:
- Use triple backticks around code blocks to preserve formatting.
- Escape backticks that may appear inside HAML code if necessary.
- Include a stable delimiter between components (`---`) and a distinct header per component (`=== Component: ...`).
- The top-level index provides quick navigation and an overview of what's available.

## Implementation Steps

### 1) Add an LLM formatter/exporter

- File to create: `docs/demo/app/services/algolia/llm_text_export_service.rb`
- Purpose: Convert the aggregated records (or raw parsed structure) into the `LLM.txt` textual format described above and write to disk.
- Responsibilities:
  - Accept either:
    - Array of Algolia-style records (from `Algolia::RecordConverterService`), OR
    - A richer collection of parsed results keyed by component, to avoid reconstructing relations from flat records.
  - Ensure stable ordering.
  - Perform safe filesystem writes (create directories as needed).

### 2) Introduce an aggregation builder for LLM output (optional but recommended)

- File to create: `docs/demo/app/services/algolia/llm_aggregation_service.rb`
- Purpose: While `RecordConverterService` produces flat records for search, `LLM.txt` benefits from grouped data by component. This service:
  - Invokes `HamlParserService` per component file (same as rake logic).
  - Returns a normalized structure:
    ```ruby
    {
      component: "Daisy::DataDisplay::ChatBubble",
      framework: "Daisy",
      section: "DataDisplay",
      base_name: "ChatBubble",
      examples_url: "...",
      api_url: "...",
      file_path: "...",
      title: "...",
      description: "...",
      examples: [ { title:, anchor:, description:, code: } ... ]
    }
    ```
- This avoids rejoining flat records and keeps formatting concerns separate from parsing.

### 3) Add a new rake task to generate LLM.txt

- File to edit: `docs/demo/lib/tasks/algolia.rake`
- Add a task `algolia:llm` with options:
  - `-c, --component NAME` limit to a single component (same as `algolia:index`).
  - `-o, --output PATH` default to `docs/LLM.txt`.
- Logic mirrors `algolia:index` selection flow, but:
  - Uses `LLMAggregationService` to collect component bundles.
  - Calls `LLMTextExportService` once with all bundles.
  - Does not require Algolia credentials.
- Example usage:
  - `docker compose exec -it demo bundle exec rake algolia:llm`
  - `make llm ARGS="--component Daisy::Actions::Modal --output docs/LLM-modal.txt"`

### 4) Update developer docs

- File to edit: `docs/dev_guides/ALGOLIA.md`
- Add a new section “Generating LLM.txt” with commands and options.
- Clarify that this export does not affect Algolia uploads.

### 5) Optional: Makefile and CI integration

- Add `make llm` target similar to `algolia-index`, running the rake task in the Docker demo container.
- Optionally add a CI job to regenerate and upload `docs/LLM.txt` as an artifact or commit (if desired).

## Implementation Details

- Reuse of path resolution from `algolia:index`:
  - Component list from `LocoMotion::COMPONENTS`.
  - File path construction under `docs/demo/app/views/examples/{framework}/{section}/{example}.html.haml`.
- Error handling matches existing rake task style (warn and continue when files are missing).
- Ordering: Use the iteration index as a `position` to keep stable output.
- Encoding: ensure all strings are UTF-8 and normalize whitespace similarly to `HamlParserService#clean_string`.

## Edge Cases & Considerations

- Missing example files: keep the warning behavior; skip that component.
- Components without examples: still include a component section with description if available.
- Very large output: `LLM.txt` may be long; keep code blocks but consider trimming overly large examples in the future via a `--max-code-lines` option (defer unless needed).
- Deterministic runs: avoid timestamps; stable sort by component name to keep diffs clean.

## Rollout Plan

1. Implement `LLMTextExportService` and `LLMAggregationService` with unit-level tests where feasible (in the demo app’s spec structure used for Algolia services).
2. Add `algolia:llm` rake task and Makefile target.
3. Update `docs/dev_guides/ALGOLIA.md` with usage and examples.
4. Manually run locally to generate `docs/LLM.txt`; review content for clarity.
5. Optionally wire into CI to publish or verify `LLM.txt` generation on PRs.

## Future Enhancements

- Include helper method names and signatures from `lib/loco_motion/helpers.rb` where available.
- Include component metadata (sizes, variants) when present in registries or doc comments.
- Add a `--markdown` flag to select `.md` output if desired, though plain text is recommended for simplicity.
