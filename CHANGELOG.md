# Changelog

All notable changes to LocoMotion will be documented in this file.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
_mostly_ adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

We say mostly because all versions before 1.0.0 will likely have breaking changes as we don't consider the
project "released" until that point in time.

We plan to use patch versions only for bug fixes, and for now, all **minor releases** should be considered
**breaking**!

## [Unreleased]

### Tooling & Standards

- chore(Lint): Add RuboCop with an intentionally minimal, opt-in `.rubocop.yml` (most cops are commented out as a
  catalog you can enable gradually) plus a `just lint` recipe. It is a developer aid, not a blocking CI gate.
- chore(Lib): Add `# frozen_string_literal: true` to every `lib/loco_motion` file that was missing it.
- chore(Gemspec): Align the development `rails` constraint with the runtime constraint (`< 8.1`) and add `rubocop`
  and `rubocop-rails` as development dependencies.
- chore(CI): Add `concurrency` cancellation and `.node-version`-driven Node setup to the workflows; add a Dependabot
  configuration. (A multi-version Rails test matrix is deferred — see
  `docs/plans/202605-4-architecture-and-standards-review.md` — because Rails 6.1/7.1 do not boot on the runner's
  Ruby 3.4 and the matrix needs verified Ruby/Rails pairings.)
- chore(Version): Add a `just version-check` guard that fails when the version drifts across `version.rb`, `VERSION`,
  and the npm package files, and document that `version.rb` is the canonical source (`VERSION` exists for the Heroku
  buildpack).
- chore(Release): Replace the `make` targets in `bin/release` with their `just` equivalents to match the project's
  task runner.
- chore(Repo): Fix the `.gitignore` `.DS_Store` pattern and remove a stray `.DS_Store` from `lib/loco_motion/patches`.
- chore(Archon): Add Archon (archon.diy) workflow tooling under `.archon/` — the `loco-new-component`
  workflow plus six command files that build a DaisyUI component end-to-end (plan, scaffold, implement,
  document, verify, e2e, draft PR) by reusing the existing Claude skills. Also gitignore the vendored
  `.claude/skills/archon/` skill and Archon runtime artifacts (`.archon/state/`, `.archon/.env`).

### Documentation

- docs(Guides): Move the generic Rails-setup content out of the README into demo-site guide pages under
  `docs/demo/app/views/guides/` (Docker, HAML, Debugging, Getting Started, Services, Authentication), exposed via
  the existing `/guides/:id` routes and linked from the demo home page; slim the README from ~1000 to ~330 lines
  ([Fixes #73](https://github.com/profoundry-us/loco_motion/issues/73)).
- docs(README): Fix the Stimulus integration example to register controllers under their required `loco-*`
  identifiers (previously `"countdown"`, which never connects) and document all four JS-backed components.
- docs(LLM): Regenerate `llms.txt` / `llms-full.txt` for v0.5.2 — they were stale at v0.5.1 and the demo's
  `/llms-v0.5.2.txt` download link pointed at a missing file.
- docs(Algolia): Correct `ALGOLIA.md` to match the real `llms.txt` / `llms-full.txt` filenames and `Llm*` service
  constants, and document `usage_patterns.md` as a required hand-maintained input.
- docs(Agents): Replace the incorrect `AGENTS.md` boilerplate with a pointer to `CLAUDE.md` and the project's
  convention sources; fix broken `.windsurfrules` links and mark `CLAUDE.md` as the canonical source.
- docs(Plans): Move completed plans into `docs/plans/archive/` and add an active-vs-archive README.

### Components Changes

- fix(Tooltip): Reveal `tip:` tooltips on keyboard focus. DaisyUI 5 only shows focus tooltips when the
  focusable element is a child of `.tooltip`, so tooltips applied via `tip:` appeared on hover but not on
  focus. The demo now ships a `.tooltip:focus-visible` rule and the Getting Started guide documents it for
  your own app ([Fixes #116](https://github.com/profoundry-us/loco_motion/issues/116)).
- fix(Breadcrumbs): Call `super` in `before_render` so the `IconableComponent` and `TippableComponent` setup hooks
  run — breadcrumb item `tip:` tooltips and icons were silently dropped before.
- fix(Rating, TimelineEvent, Steps, Dock): Call `super` in `before_render` overrides so concern setup hooks are no
  longer silently skipped.
- fix(Countdown): Add `disconnect()` to the Stimulus controller to clear its interval and prevent a timer leak on
  Turbo navigation.
- fix(ThemeController): Guard `localStorage` access (Safari private-browsing mode) and return `null` from
  `getCurrentTheme` when no theme is saved.
- fix(Avatar, Figure): Add an `alt:` option for the image so avatar and figure images are accessible to screen
  readers.
- fix(Steps): Correct the `StepComponent` `attr_reader` to reference the actual `@simple_title` ivar instead of a
  nonexistent `@simple`.
- fix(Iconable): Default `left_icon_options` to `icon_options` instead of `icon_html` (copy-paste error).
- docs(TimelineEvent): Add the missing `@loco_example` documentation blocks.

- fix(Theme): Add `theme_preload_script` helper to prevent flash of content when loading with non-default
  theme ([Fixes #49](https://github.com/profoundry-us/loco_motion/issues/49))
- fix(Theme): Update `clearTheme` method to remove `data-theme` attribute from document element, preventing
  need for page refresh when clearing theme

- feat(DataInput): Add `AriableComponent` concern to Checkbox, Toggle, RadioButton, TextInput, TextArea,
  Select, Range, and FileInput that automatically sets `aria-required="true"` when `required: true` is passed
  (unless the user provides `aria-required` explicitly)
- feat(RadioButton): Add LabelableComponent concern with start/end label support and custom content blocks
- feat(Checkbox): Add label examples for start/end labels and custom content blocks
- feat(Join): Add automatic `join-item` CSS class injection for items slot using
  `BasicComponent.build(css: "join-item")`
- feat(Join): Add `buttons` slot using `ButtonComponent.build(css: "join-item")` for automatic CSS class
  injection
- feat(Join): Add `radios` slot using `RadioButtonComponent.build(skip_styling: true, css: "join-item btn")`
  for automatic CSS class injection
- feat(Join): Update call method to handle items, buttons, radios, or direct content
- fix(Diff): Replace comment-based Tailwind class safelist with `ITEM_CLASSES` constant so `diff-item-1` /
  `diff-item-2` are detected as string literals by Tailwind v4's Ruby extractor
  ([Fixes #82](https://github.com/profoundry-us/loco_motion/issues/82))
- add(Hover): Add new `Daisy::Layout::HoverComponent` (`daisy_hover`) wrapping DaisyUI's `hover-3d` effect,
  with optional `href:`/`target:` for clickable 3D cards via `LinkableComponent`
  ([Fixes #80](https://github.com/profoundry-us/loco_motion/issues/80))
- feat(HoverGallery): Add new `Daisy::Layout::HoverGalleryComponent` (`daisy_hover_gallery`) with slot-based
  `with_image` API, `srcs:` convenience shorthand, content fallback for custom block markup, and demo examples
  ([Fixes #96](https://github.com/profoundry-us/loco_motion/issues/96))
- fix(HoverGallery): Replace non-existent `set_tag` with `set_tag_name` in `setup_component`, and move
  `ImageComponent` tag assignment from `initialize` to `before_render` via `set_tag_name(:component, :img)`
- fix(Avatar): Suppress `where:bg-neutral` default on placeholder wrapper when `skeleton` is in `wrapper_css`,
  preventing the neutral background from bleeding through the skeleton shimmer gradient
  ([Fixes #98](https://github.com/profoundry-us/loco_motion/issues/98))
- fix(Skeleton): Standardize text-hiding in component skeleton examples (`text-transparent` consistently); add
  `skeleton-text` example and docs for DaisyUI 5's animated text shimmer class
  ([Fixes #98](https://github.com/profoundry-us/loco_motion/issues/98))
- feat(DataDisplay): Add new `Daisy::DataDisplay::TextRotateComponent` (`daisy_text_rotate`) with
  `ItemComponent` slot, `texts:` shorthand parameter, a `wrapper` part (`wrapper_css:`) around the items,
  tooltip support, custom block content (rendered after items), and per-item link (`href`) / icon
  (`left_icon`/`right_icon`) support via `LinkableComponent` and `IconableComponent`
  ([Fixes #110](https://github.com/profoundry-us/loco_motion/issues/110))
- feat(Link): Add icon support (`icon`, `left_icon`, `right_icon`) to `LinkComponent` via `IconableComponent`
  concern, matching `ButtonComponent` feature parity
  ([Fixes #84](https://github.com/profoundry-us/loco_motion/issues/84))
- feat(Navbar): Allow custom content to be passed directly inside the component's block in addition to the
  existing `start`, `center`, and `end` slots
  ([Fixes #83](https://github.com/profoundry-us/loco_motion/issues/83))
- feat(Alert): Add auto-dismiss functionality with `autoclose` and `timeout` parameters
- feat(Alert): Add clickable link functionality with `href` and `target` parameters
- feat(Alert): Add Stimulus action support with `action` parameter
- feat(Alert): Add closable functionality with `closable` parameter and close button
- feat(Alert): Add AlertController to NPM package for client-side alert management
- feat(Configuration): Add comprehensive documentation to Configuration class
- add(FAB): Add new `Daisy::Actions::FabComponent` (`daisy_fab`) implementing the DaisyUI FAB / Speed Dial
  pattern with `button`, `activator`, and `action` slots
  ([Fixes #93](https://github.com/profoundry-us/loco_motion/issues/93))
- fix(DeviceComponent): Fix tablet mockup for DaisyUI v5 by removing dead `!mt-0` hack and moving sizing to
  the container via `css:` (override `aspect-ratio`, `max-width`, `border-radius`) instead of `display_css`
  ([Fixes #99](https://github.com/profoundry-us/loco_motion/issues/99))
- fix(Theme): Auto-sync the selected theme across every theme selector on the page by watching `change` events
  and making `setInput` uncheck stale inputs, so a selection in one switcher is no longer silently overridden
  by another; radio inputs now persist to `localStorage` automatically with no `setTheme` action wiring
  ([Fixes #115](https://github.com/profoundry-us/loco_motion/issues/115))
- fix(Theme): Namespace `build_radio_input` ids by input name (`"#{name}-#{theme}"`) to avoid duplicate ids
  when multiple theme controllers share a page

### General Changes

- chore(Skills): Split `start-issue` into two focused skills: `create-issue` (investigate → draft → post a
  GitHub issue) and `start-issue` (read an existing issue, propose a branch, optionally plan)
- feat(BaseComponent): Add universal `aria:` / `data:` shorthands (and per-part `{part}_aria` / `{part}_data`)
  that deep-merge into a part's HTML, so `aria: { label: "Save" }` renders `aria-label="Save"` without nesting
  inside `html:`
- feat(ComponentConfig): Add `add_aria` / `add_data` author helpers (delegated from `BaseComponent`) for
  setting default `aria-*` / `data-*` attributes on a part
- feat(BaseComponent): Improve `build` method to merge build_kws into config before initialize for proper
  precedence
- feat(BaseComponent): Update instance variables for build_kws keys after initialize to ensure options like
  `skip_styling` are available during `setup_component`
- feat(RadioButton): Move rendering from call method to HAML template to match CheckboxComponent pattern
- chore(justfile): Rename the `*-quick` targets (`all-quick`, `loco-quick`, `demo-quick`, `yard-quick`) to
  `*-fast`

### Demo / Docs Changes

- fix(demo): Add `ads_preload_script` helper to prevent flash of ads content when page loads
- fix(demo): Move `ads_preload_script` after ads element in layout since it needs to query for specific DOM
  elements
- fix(demo): Add Playwright test to verify ads visibility is set correctly on non-hidden pages
- add(Docs): Add missing page titles to Install, LLMs, Docker, HAML, and Debugging pages
- feat(Join): Update join examples to use `with_button` slot instead of `with_item` for buttons
- feat(Join): Add expansive direct content example with input, select, and indicator components
- feat(RadioButton): Add radio buttons with labels examples to demo
- add(Hover): Add "Hover 3D" demo page with basic, clickable card, and image gallery examples
- add(Demo): Add `Dockerfile.demo.cloud` for building the demo app in network-restricted environments (e.g.
  Claude Code cloud) where OS package repos are blocked; uses a multi-stage build to copy Node.js from
  `node:20-slim` instead of installing via `nodesource`
- add(Navbar): Add "Custom Content Navbar" example demonstrating block-based custom content
- feat(Alert): Add closable, auto-dismissing, clickable link, and Stimulus action alert examples
- feat(Alert): Add AlertDemoController for interactive click celebration demo
- feat(Toast): Enhance Toast examples with closable, auto-dismiss, and clickable features
- feat(Toast): Add Toast positions example and reset functionality
- docs(Toast): Update documentation to warn about AlertController dependency
- docs(Alert): Update Alert examples with improved descriptions and formatting
- add(FAB): Add FAB demo page with simple, speed dial, flower, and custom activator examples
- add(HoverGallery): Add Hover Galleries demo page with Basic, In a Card, and Shorthand (`srcs:`) examples
- add(TextRotate): Add Text Rotates demo page with examples for Basic usage, `texts:` shorthand, Centered
  Items (`wrapper_css:`), Icons and Links (per-item `icon`/`left_icon`/`right_icon` and `href`), Custom
  Content (custom block markup with inline `daisy_avatar`s beside the text), Custom Duration (3s/6s/10s),
  Inline in a Sentence, Different Font Sizes, and Custom Line Height
- docs(Skills): Add `run-demo` skill for booting the demo Rails app locally without Docker, including
  Ruby/Node version handling, vendor symlink setup, and the `file:../..` + `--no-lockfile` yarn pattern to
  avoid polluting `yarn.lock`
- docs(Skills): Add `screenshot-demo` skill for capturing full-page screenshots and videos of demo pages via
  Playwright, depending on `run-demo`
- docs(Skills): Update `create-pr` skill with label-selection guidance and a follow-up
  `mcp__github__issue_write` step to apply labels after PR creation
- docs(Theme): Update the Theme Controller "Theme Radio Inputs" example note to document the automatic
  syncing, and link the preload-script note to the `ThemeHelper` API docs
- chore(demo): Switch the header version badge to a "View All Releases" tip linking to the GitHub releases
  page, and remove the stale issue #49 flash-of-content comment
- fix(demo): Restore plain-Ruby guard in `docs/demo/bin/bundle` — `.present?` (ActiveSupport) is not
  available when the binstub runs, causing a `NoMethodError` on Heroku during `bundle install`

### Changed

- **Heroku Configuration**: Added buildpack configuration to <code>app.json</code> for Heroku Review Apps
  - Added custom <code>loco_motion-buildpack</code> to copy <code>docs/demo</code> subdirectory and gem files
  - Added <code>heroku/ruby</code> and <code>heroku/nodejs</code> buildpacks
  - Custom buildpack must run first to ensure files are in place before standard buildpacks execute
- **Developer Tooling**: Add `CLAUDE.md` at the repo root referencing all Windsurf rule files so Claude Code
  sessions pick up the same coding conventions as Windsurf
  ([Fixes #90](https://github.com/profoundry-us/loco_motion/issues/90))

## [0.5.2] - 2026-03-05

### Fixed

- Update DaisyUI and TailwindCSS to their latest patch versions for bug fixes and improvements
  - DaisyUI: v5.5.14 → v5.5.19
  - TailwindCSS: v4.1.18 → v4.2.1
  - @tailwindcss/cli: v4.1.18 → v4.2.1

### Changed

- **Branding**: Updated project logo to modern version across all documentation and examples
  - Replaced `loco-logo.png` with `loco-logo-modern.png` in navbar and frame examples
  - Updated LLM documentation files to reflect new logo references
  - Added new modern favicon (`loco-favicon.jpg`)

## [0.5.1] - 2025-09-25

### Fixed

- Update DaisyUI and TailwindCSS to their latest patch versions for bug fixes and improvements
- Remove alpha status badge from the website header as the project is now considered stable

### Improved

- **Release Process**: Refactored release workflow to eliminate circular dependency issues
  - Split `make version-lock` into separate `loco-version-lock` and `demo-version-lock` commands
  - Added new `bin/update_demo_after_release` script for post-publication demo updates
  - Updated release documentation to use two-phase approach (package release → demo update)
  - Reordered release steps to update changelog before building packages
  - Enhanced Makefile targets with NPM package availability checking
  - **Automated checklist creation**: `make version-bump` and `make version-set` now automatically create
    personalized release checklists
- **Documentation**: Added comprehensive release checklist template and improved release guide clarity

## [0.5.0] - 2025-07-17

### Overview

This is a **MASSIVE** release which touches basically every component!

We've upgraded both TailwindCSS and DaisyUI to the latest major versions (4.x and 5.x respectively) with lots
of new features and components!

> [!NOTE]
> Please refer to the [DaisyUI Upgrade Guide](https://daisyui.com/docs/upgrade) for specific changes to the
> styling of components.

We've overhauled the entire docs site to be easier to use (better navigation styling) and quicker to navigate
(super-fast Algolia search :exploding_head:).

We've also added some new components offered by DaisyUI 5 including:

- Fieldset
- List
- Status

And we updated many examples to be more clear or show other usage scenarios.

Lastly, we added a TON of tests to ensure that all of the components function as designed and will continue to
as we add more features.

Read on for specific changes across the entire project! :tada:

### Added

- add(`where:`): Add custom `where:` Tailwind modifier
- add(List): Add basic List component with examples and specs
  ([Fixes #29](https://github.com/profoundry-us/loco_motion/issues/29))
- add(Fieldset): Add Fieldset component for grouping related form elements
  ([Fixes #32](https://github.com/profoundry-us/loco_motion/issues/32))
- add(Status): Add Status component for displaying visual status indicators
  ([Fixes #30](https://github.com/profoundry-us/loco_motion/issues/30))
- feat(LabelableComponent): New concern to enable label functionality across components
- feat(Select): Enable start/end/floating label functionality
- feat(Toggle): Enable start/end/floating label functionality
- feat(Checkbox): Enable start/end label functionality
- feat(Filter): Add Filter component for creating selection interfaces with toggle functionality
  ([Fixes #33](https://github.com/profoundry-us/loco_motion/issues/33))
- feat(Cally): Add new Daisy Cally and CallyInput components with date picker functionality
- feat(Select): Add support for array and hash options in select component
- feat(Select): Add floating label support for select inputs
- feat(Labelable): Enhance labelable component behavior for better form handling

### Changed / Fixed

#### General Changes

- **Breaking:** Upgrade from TailwindCSS 3.x to 4.x and DaisyUI 4.x to 5.x
  ([PR #42](https://github.com/profoundry-us/loco_motion/pull/42))
- **Breaking:** Update existing components for DaisyUI 5 compatibility
  ([PR #28](https://github.com/profoundry-us/loco_motion/pull/28))
- **Breaking:** All inputs now have a border by default, use `input-ghost` (or `*-input-ghost`) to remove (see
  [DaisyUI Upgrade Guide](https://daisyui.com/docs/upgrade))
- **Breaking:** Migrated BottomNav component to Dock component to match DaisyUI 5 changes
  ([Fixes #40](https://github.com/profoundry-us/loco_motion/issues/40)):
  - `BottomNavComponent` → `DockComponent`
  - Helper method `daisy_bottom_nav` → `daisy_dock`
  - Updated all CSS classes, slot/part names, and icon rendering to new conventions
  - Example views and tests updated accordingly
  - This is a breaking change: update any usages of the old component and helper to the new names and API
- feat: Allow users to pass singular `controller:` keyword in addition to `controllers:`
- refactor: Implement Concern Lifecycle Hooks in `BaseComponent` for consistent initialization and setup
  ([PR #54](https://github.com/profoundry-us/loco_motion/pull/54))
- refactor: Move component concerns to lib directory for better organization
- test: Add comprehensive tests for IconableComponent, LinkableComponent, and TippableComponent
- refactor: The Loco parent is now set automatically in slots (`slot_loco_parent_patch.rb`) and you can pass
  the `loco_parent` option when creating a new component to set it manually when needed

#### Component Changes

- **Breaking:** remove(Artboard): Remove Artboard component no longer offered by DaisyUI 5
  ([PR #43](https://github.com/profoundry-us/loco_motion/pull/43))
- **Breaking:** refactor(Device): Utilize standard Tailwind width/height classes instead of Artboard
  ([PR #43](https://github.com/profoundry-us/loco_motion/pull/43))
- **Breaking:** refactor(ThemeController): Migrate to a "Builder" component
  ([Fixes #38](https://github.com/profoundry-us/loco_motion/issues/38))
- **Breaking:** remove(`form-control`): Remove all references to DaisyUI 4 `form-control` class (including
  specs)
- **Breaking:** change(Modal): Modal titles now render as an `<h4>` instead of a `<div>`
- **Breaking:** change(Icon): Hero icons now use the https://rubygems.org/gems/rails_heroicon library which
  means the existing `heroicon_tag` helper is replaced with the `heroicon` helper
  ([Fixes #47](https://github.com/profoundry-us/loco_motion/issues/47))

- feat(Avatar): Add support for icons and linking via `IconableComponent` and `LinkableComponent`
- feat(Badge): Add support for icons and linking and styling, including new `badge-soft` and `badge-dashed`
  variants
- feat(Button): Enhanced with new features and styling, including new `btn-soft` and `btn-dashed` variants
- feat(Alert): Enhanced with new styling options, including `alert-soft` and `alert-dashed` variants
- feat(Breadcrumbs): Refined implementation for better usability
- feat(Menu): Enhanced styling and functionality
- feat(Steps): Enhanced for better visual presentation
- feat(Tabs): Added five different size options (xs, sm, md, lg, xl)
- feat(Input): Add `daisy_input` alias helper in addition to `daisy_text_input`
- fix(Link): Tooltips now work correctly
- fix(Dropdown): Simplify item rendering and add `where:` modifier to relevant CSS classes
- fix(KBD): Accept a simple title
- fix(Modal): Only show actions part if provided
- fix(Modal): Remove unnecessary `:dialog` part from component definition
  ([Fixes #46](https://github.com/profoundry-us/loco_motion/issues/46))
- fix(Navbar): Improved implementation and styling
- refactor(DocExample): Renamed from `ExampleWrapper` for better semantics and improved code organization
- fix(Fieldset): Fix issue with fieldset textarea rendering

#### Demo / Docs Changes

- fix: Issues with the side navigation
- fix: Navigation drawer issues and dark mode configuration
- fix: Broken DocExample JavaScript
- fix: Padding issue with ThemeController
- fix: Issues with swaps (rotation issue remains)
- fix: Navigation not updating active state on selection
- fix: Padding issue on Dropdowns example by upgrading to latest Tailwind insiders
- feat: Dark mode toggle functionality
- fix: Device mockups in dark mode
- fix: Header and buttons in dark mode
- fix: Doc example tab roundness
- fix: Margin in chat bubble examples
- fix: Hero layouts and patched DaisyUI 5 bug
- fix: Maximum width for footers
- fix: Alert widths and tooltip example layout
- fix: Navbar examples with container and height adjustments
- fix: Select examples by removing duplicate Canada option
- fix: Form example issues
- fix: Rating examples with containers
- fix: Range example with w-full class
- fix: Footer heart icon color on different themes
- fix: Layout issues across multiple components
- fix: Checkbox examples with colors and sizes
- fix: Rails form builder example for checkboxes
- fix: Stats layouts
- fix: Issues with reset functionality for examples
- fix: Stack demos
- fix: Size of countdown boxes example
- fix: Width of collapses
- fix: Border to bottom figure example
- feat: Standardize H1/H2 doc headings
- feat: Enhanced navigation with icons, colors, and improved padding
- add: Algolia search indexing and UI ([Fixes #37](https://github.com/profoundry-us/loco_motion/issues/37))
- feat(AlgoliaSearch): Add auto-selection of first search result on query for improved UX
- refactor: Renamed `ExampleWrapper` doc component to `DocExample` for better semantics
- fix: Converted most uses of code blocks to markdown backticks for improved readability
- fix(DocNote): Fix purple TODO variant text color.
- refactor: Merge `application.js` functionality into `index.js`
- feat: Add Theme Switcher dropdown to header
- fix: Fix header item spacing / padding on smaller screens
- fix: Rename `Data` group to `Data Display` to match component module & DaisyUI 5
- fix: Make Label docs show better buttons for implementing components
- fix: Add tooltips to header buttons and make logo a link
- fix: Always enable BetterErrors in development
- fix: Header Theme Switcher was using the wrong button size
- feat: Add soft, outline, and dash style examples to Alert, Badge, and Button examples
  ([Fixes #36](https://github.com/profoundry-us/loco_motion/issues/36))
- feat: Updated component documentation to use `@loco_example` tag for better organization
- add(DocNote): Add new error modifier to doc_note component for improved documentation
- fix: Fix issue with figures not showing captions
- fix: Fix typo in select docs
- fix: Add check in set_loco_parent_patch to ensure we catch nil references
- fix: Use shorthand floating_placeholder for label examples
- add: Add todos about better API doc buttons
- fix: Fix bug in boxed countdown example

## [0.4.0] - 2025-03-07

This version is a major milestone as it finishes out a basic version of all of the DaisyUI 4 components!

While this gives us a solid foundation to start using the components, we feel that our time will best be spent
upgrading the configuration and components to utilize the new DaisyUI 5 framework that was recently released.

We will be migrating to the new version and all bug fixes / improvements will be made in a new LocoMotion
0.5.0 branch / release.

### Added

- Complete set of DataInput components:
  - Checkbox Component: With toggle mode and indeterminate state support
  - Label Component: For form input labels with required state
  - Radio Button Component: For option group selections
  - Range Component: Slider input with min/max/step support
  - Rating Component: Star-based rating with customizable options
  - Select Component: Dropdown with option groups and custom rendering
  - Toggle Component: Stylized toggle switch extending checkbox
  - FileInput Component: For file uploads with multiple file support
  - TextInput Component: With start/end slots for icons and buttons
  - TextArea Component: Multi-line input with rows/cols support
- Form builder integration for all DataInput components
- Comprehensive documentation and examples for each component

### Changed

- Updated README with current status and future plans
- Improved release documentation process
- Added `loco-update` command to Makefile for bundle management
- Optimized component code with frozen_string_literal directives
- Updated Windsurf rules for better AI interactions

### Fixed

- Fixed component documentation typos and inconsistencies
- Fixed masks example by adding tooltips for better UX
- Improved empty part rendering in textarea elements

## [0.0.8] - 2025-03-01

### Added

- Mockup components (Browser, Code, Device, Frame)
- Improved component documentation using Windsurf
- Comprehensive test coverage for all components

### Changed

- Improved release process and Rails compatibility
- Version management improvements
- Enhanced commit message formatting for Windsurf
- Updated Rails dependency to support both Rails 6.1 and 7.1 (`>= 6.1, < 8.0`)
- Added Windsurf rule for file removal operations

### Fixed

- Fixed Button component bug where styles were not always applied with icon options
- Fixed compatibility issues between the gem and the demo app
- Fixed Gemfile.lock not getting saved properly during version updates

## [0.0.7-docs] - 2025-02-29

### Changed

- Run gem build and publish commands in Docker
- Updated lockfiles to proper version

## [0.0.7] - 2025-02-28

### Added

- Daisy Layout Components
- Daisy Feedback Components
- API Docs links to all examples
- New homepage design

### Fixed

- Various grammatical issues in documentation
- Bug with image links in tooltips and chat bubbles examples
- Several padding issues in UI components
- Bug with API docs redirect
- Homepage improvements
- Fixed typo in tooltips and added TODO for future enhancement
- Minor fixes found after pushing to staging environment

## [0.0.6] - 2025-02-27

### Added

- Published Yard documentation
- Published RubyGem package
- Published NPM package

### Changed

- Removed docs assets sync (now hosted separately)

### Fixed

- Fixed production deployment issues for Heroku
- Fixed local references to loco_motion gem
- Fixed issue with Gemfile revisions caused by a commit --amend

## [0.0.5] - 2025-02-26

### Added

- Navigation components
- Custom documentation components
- Disclaimer about frequent changes

### Changed

- Improved documentation with code examples
- Heroku configuration updates

### Fixed

- Fixed bugs in multiple Data components
- Fixed issues with code examples display

## [0.0.4] - 2025-02-25

### Added

- Completed Data Display components
- Stats component
- Avatar component with various status indicators
- Kbd component with examples
- Basic navigation and example views

### Changed

- Upgraded to Ruby 3.3.2
- Project cleanup for contributors

### Fixed

- Fixed CI/CD GitHub Action configuration
- Fixed Yard documentation requiring bundle to start

## [0.0.3] - 2025-02-24

### Added

- Modal component with basic functionality
- ADR (Architecture Decision Record) for sizes and variants
- Badge component

### Changed

- Refactored variants to modifiers
- Improved component testing setup

### Fixed

- Fixed missing quote newlines
- Fixed test specifications
- Removed unnecessary code and fixed build process

## [0.0.2] - 2025-02-23

### Added

- Basic Rails demo app integration
- Yard documentation setup
- GitHub Actions for CI/CD and testing

### Changed

- Converted to Rails engine for autoloading
- Component configuration object
- Version bumped to 0.0.4 (internal)

### Fixed

- Fixed development issues with BaseComponent
- Fixed Yard documentation setup issues

## [0.0.1] - 2025-02-22

### Added

- Initial project setup
- Base component structure
- Tailwind integration
- Documentation and README
- Docker configuration

### Fixed

- Fixed README links and styling
- Fixed issues with Tailwind integration
- Added workarounds for Auth, Web Console, and Better Errors
