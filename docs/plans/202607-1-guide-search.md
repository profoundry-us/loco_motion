# Guide & Docs Search: Index Demo Guides and Docs Pages into Algolia

## Overview

Demo-site search today covers only **component examples**: `rake
algolia:index` walks `LocoMotion::COMPONENTS`, parses each example HAML file,
and uploads records to a single version-pinned index
(`loco_motion_{env}_components_{version}`), which the InstantSearch modal
queries. The nine dev guides under `docs/demo/app/views/guides/` and the
docs pages under `docs/demo/app/views/docs/` (install, icons, llms, …) are
invisible to search.

This plan indexes both **section-by-section** (one record per `h2`, linking
to its anchor) into the *same* index, and teaches the search UI to present
them with **three visually distinct icons**: components keep their current
icon, guides get their own, and docs pages get a third.

**Scope note**: this is a demo-app upgrade only — no gem/npm surface
changes. Target: land on `main` before `bin/release 0.7.1` so it ships with
that release's deploy (the Heroku release phase reindexes automatically;
nothing new to operate). Each PR carries a CHANGELOG entry under
**Demo / Docs Changes**.

**Key design decisions:**

- **Same index, not a second index.** InstantSearch queries one index with
  one search operation per keystroke. A separate index would require
  federated multi-index search (more UI plumbing, double quota burn per
  keystroke — quota is already a watched resource; see the lazy-init
  comment in `algolia_search.js`).
- **Reuse the existing `type` attribute.** Records already carry `type`
  (the hit renderer branches on `hit.type == "example"`); new records use
  `type: "guide"` and `type: "doc"` instead of introducing a parallel
  `record_type` attribute.


## Related Issues

None filed — planned in-session 2026-07-30. Timing interacts with the
pending `v0.7.1` release (issues #358/#340): merge before the release runs
so the deploy picks it up; otherwise it waits for 0.8.0 or a cherry-pick
onto `stable`.


## External Resources

- [Algolia batch operations](https://www.algolia.com/doc/api-reference/api-methods/batch/)
  — already wrapped by `Algolia::Index#save_objects`.
- [InstantSearch.js connectHits](https://www.algolia.com/doc/api-reference/widgets/hits/js/#connector)
  — the custom hit renderer we extend.
- [Heroicons](https://heroicons.com) — source for the two new inline SVGs.
  Match the app's own nav iconography (`ApplicationController`'s
  `setup_nav_sections`): docs = `book-open`, guides = `document-text`.
- Existing pipeline (reference implementations):
  - `docs/demo/lib/tasks/algolia.rake` — orchestration + JSON fallback
  - `docs/demo/app/services/algolia/` — extractor / converter / import
  - `docs/demo/app/javascript/algolia_search.js` — modal UI, lazy init,
    per-type hit templates (`componentTemplate` / `exampleTemplate`) and
    inline SVG icon constants (`componentIcon`, `exampleIcon`, …)
  - `docs/demo/app/services/algolia/index.rb` — naming + index settings


## Implementation Steps

Split into **two dependency-ordered PRs** (infrastructure first, UI second).
Each PR ships its own tests and its own **Demo / Docs Changes** CHANGELOG
entry.


### PR 1 — Page extraction + indexing (guides and docs)

#### 1. Create the page extractor service

**Purpose**: Produce one Algolia record per page *section* so hits deep-link
to anchors instead of dumping users at the top of a long page. One service
handles both view directories — the pages share the doc-page house style.

**Files to Create**:

- `docs/demo/app/services/algolia/page_metadata_extractor.rb`
- `docs/demo/spec/services/algolia/page_metadata_extractor_spec.rb`

**Approach**: Render each page through the real pipeline rather than
parsing HAML by hand (the pages lean on `:markdown` filters and `doc_*`
helpers that a source-parse would misread):

1. Enumerate `app/views/guides/*.html.haml` and
   `app/views/docs/*.html.haml` (skip partials like `_wip_warning`).
2. Render via `ApplicationController.render(template: ...)`.
3. Parse with Nokogiri; split on `h2` (the house style gives every section
   an `id` anchor and a `scroll-mt-24` class — the anchors are already
   there for the steps-roadmap links).
4. Per section emit:
   - `objectID`: `"guide-#{id}-#{anchor}"` / `"doc-#{id}-#{anchor}"`
     (stable across reindexes)
   - `type`: `"guide"` or `"doc"`
   - `title`: section heading; `page_title`: the page's own title
   - `description`: first ~40 words of the section's text content
   - `url`: `/guides/#{id}##{anchor}` or `/docs/#{id}##{anchor}`
     (page-level record without fragment when a page has no `h2`s)
   - `section`: `"Guides"` / `"Docs"` (feeds the existing
     `filterOnly(section)` facet)
   - `priority`: components stay first for ambiguous terms like "button"
     (components 1–2, docs 4, guides 5 — docs slightly above guides since
     setup content answers more searches; tune in review)

#### 2. Wire into the rake task

**Purpose**: Guides and docs reindex wherever components do — including the
Heroku release phase — with zero new operational steps.

**Files to Edit**:

- `docs/demo/lib/tasks/algolia.rake`

**Changes to Make**: After the component loop, run the page extractor and
append its records to `all_records` so they ride the same JSON export and
`save_objects` upload. Respect existing flags: `--component X` implies
pages are skipped; add `--skip-pages` for symmetry. The JSON-fallback path
(no credentials) must include page records too, so specs can assert on the
export without hitting Algolia.

#### 3. Confirm component records carry a distinct `type`

**Purpose**: The UI branches on `type` for icon choice, so every record
needs an unambiguous value.

**Files to Edit**:
`docs/demo/app/services/algolia/record_converter_service.rb` (only if
needed)

**Changes to Make**: Verify existing component/example records always set
`type`; backfill a default only if any record ships without one. Additive —
no existing attribute changes, so the UI keeps working against a
half-migrated index during rollout.

#### 4. Tests + CHANGELOG (PR 1)

- Extractor spec: renders one real guide and one real docs page, asserts
  ≥ 1 record per `h2`, stable `objectID`s, anchor URLs, correct `type` and
  `section` per directory, and that partials are skipped.
- Export-level assertion: JSON export with `--skip-upload` contains
  `guide` and `doc` records alongside component records.
- CHANGELOG: Demo / Docs Changes entry describing the indexing.


### PR 2 — Search UI

#### 5. Surface guide/doc hits with distinct icons

**Purpose**: Users can tell result kinds apart at a glance — three icons:
components (existing icon, unchanged), guides (new), docs pages (new).

**Files to Edit**:

- `docs/demo/app/javascript/algolia_search.js`

**Changes to Make**:

- Add two inline SVG constants alongside the existing `componentIcon` /
  `exampleIcon` (same pattern — inline SVG in the JS, so the demo's strict
  `loco_icon` sync rules aren't in play): `docIcon` (`book-open`) and
  `guideIcon` (`document-text`), matching the sidebar nav's icon
  assignments so the two surfaces agree.
- Add a `pageTemplate(hit)` (guide/doc rows: icon by `hit.type`, title,
  snippet, anchor-aware link) and branch the `groupTemplate` hit dispatch
  on `hit.type` (`"guide"` / `"doc"` / existing example/component paths).
- Grouping: search-mode grouping currently keys on `hit.component`; page
  hits group under their `page_title` instead so a guide's sections
  cluster together.
- Verify keyboard navigation (`currentSearchResultIndex`) still traverses
  the full flat list across groups, and `visitDoc` handles anchor URLs.

#### 6. Verification + CHANGELOG (PR 2)

**Commands to Run**:

```bash
just demo-test
```

```bash
docker compose exec -T demo bundle exec rake algolia:index ARGS="--skip-upload"
```

```bash
just algolia-index
```

**Expected Results**:

- Demo suite green.
- `--skip-upload` JSON contains guide + doc records with anchors
  (inspect `tmp/algolia/algolia_index.json`).
- After the real local index run: searching "authentication" surfaces a
  guide hit with the guide icon; "install" surfaces a docs hit with the
  docs icon; both deep-link to the right section; "button" still ranks
  components (unchanged icon) first.
- Visual pass on the modal in light + dark themes (icons legible in both).
- CHANGELOG: Demo / Docs Changes entry for the UI.
- Playwright: run the existing e2e suite; add a search e2e only if one
  already covers the modal (local flakes memory says keep e2e lean).


## Rollout / Timing

1. Land both PRs on `main` before running `bin/release 0.7.1`.
2. The release deploy reindexes staging + production automatically (release
   phase), creating `loco_motion_{env}_components_0.7.1` with guide and doc
   records included from day one. No index migration: old version-pinned
   indexes are simply superseded.
3. If 0.7.1 ships first, options are: wait for 0.8.0, or cherry-pick onto
   `stable` (requires the wizard's stable push to move to
   `--force-with-lease` — two-line change, do it only when first needed).


## Out of Scope

- Federated/multi-index search, search analytics, synonyms.
- Renaming the index short name away from `components`.
