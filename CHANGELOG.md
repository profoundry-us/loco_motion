# Changelog

All notable changes to LocoMotion will be documented in this file.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project _mostly_ adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

We say mostly because all versions before 1.0.0 will likely have breaking
changes as we don't consider the project "released" until that point in time.

We plan to use patch versions only for bug fixes, and for now, all **minor
releases** should be considered **breaking**!

## [0.5.0] - Unreleased

### Overview

This is a **MASSIVE** release which touches basically every component!

We've upgraded both TailwindCSS and DaisyUI to the latest major versions (4.x
and 5.x respectively) with lots of new features and components!

> [!NOTE]
> Please refer to the [DaisyUI Upgrade Guide](https://daisyui.com/docs/upgrade)
> for specific changes to the styling of components.

We've overhauled the entire docs site to be easier to use (better navigation
styling) and quicker to navigate (super-fast Algolia search :exploding_head:).

We've also added some new components offered by DaisyUI 5 including:

- Fieldset
- List
- Status

And we updated many examples to be more clear or show other usage scenarios.

Lastly, we added a TON of tests to ensure that all of the components function as
designed and will continue to as we add more features.

Read on for specific changes across the entire project! :tada:

### Added

- add(`where:`): Add custom `where:` Tailwind modifier
- add(List): Add basic List component with examples and specs ([Fixes #29](https://github.com/profoundry-us/loco_motion/issues/29))
- add(Fieldset): Add Fieldset component for grouping related form elements ([Fixes #32](https://github.com/profoundry-us/loco_motion/issues/32))
- add(Status): Add Status component for displaying visual status indicators ([Fixes #30](https://github.com/profoundry-us/loco_motion/issues/30))
- feat(LabelableComponent): New concern to enable label functionality across components
- feat(Select): Enable start/end/floating label functionality
- feat(Toggle): Enable start/end/floating label functionality
- feat(Checkbox): Enable start/end label functionality

### Changed / Fixed

#### General Changes

- **Breaking:** Upgrade from TailwindCSS 3.x to 4.x and DaisyUI 4.x to 5.x ([PR #42](https://github.com/profoundry-us/loco_motion/pull/42))
- **Breaking:** Update existing components for DaisyUI 5 compatibility ([PR #28](https://github.com/profoundry-us/loco_motion/pull/28))
- **Breaking:** All inputs now have a border by default, use `input-ghost` (or `*-input-ghost`) to remove (see [DaisyUI Upgrade Guide](https://daisyui.com/docs/upgrade))
- **Breaking:** Migrated BottomNav component to Dock component to match DaisyUI 5 changes ([Fixes #40](https://github.com/profoundry-us/loco_motion/issues/40)):
  - `BottomNavComponent` → `DockComponent`
  - Helper method `daisy_bottom_nav` → `daisy_dock`
  - Updated all CSS classes, slot/part names, and icon rendering to new conventions
  - Example views and tests updated accordingly
  - This is a breaking change: update any usages of the old component and helper to the new names and API
- feat: Allow users to pass singular `controller:` keyword in addition to `controllers:`
- refactor: Implement Concern Lifecycle Hooks in `BaseComponent` for consistent initialization and setup ([PR #54](https://github.com/profoundry-us/loco_motion/pull/54))
- refactor: Move component concerns to lib directory for better organization
- test: Add comprehensive tests for IconableComponent, LinkableComponent, and TippableComponent

#### Component Changes

- **Breaking:** remove(Artboard): Remove Artboard component no longer offered by DaisyUI 5 ([PR #43](https://github.com/profoundry-us/loco_motion/pull/43))
- **Breaking:** refactor(Device): Utilize standard Tailwind width/height classes instead of Artboard ([PR #43](https://github.com/profoundry-us/loco_motion/pull/43))
- **Breaking:** refactor(ThemeController): Migrate to a "Builder" component ([Fixes #38](https://github.com/profoundry-us/loco_motion/issues/38))
- **Breaking:** remove(`form-control`): Remove all references to DaisyUI 4 `form-control` class (including specs)

- feat(Avatar): Add support for icons and linking via `IconableComponent` and `LinkableComponent`
- feat(Badge): Add support for icons and linking and styling, including new `badge-soft` and `badge-dashed` variants
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
- fix(Modal): Remove unnecessary `:dialog` part from component definition ([Fixes #46](https://github.com/profoundry-us/loco_motion/issues/46))
- fix(Navbar): Improved implementation and styling
- refactor(DocExample): Renamed from `ExampleWrapper` for better semantics and improved code organization

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
- feat: Add soft, outline, and dash style examples to Alert, Badge, and Button examples ([Fixes #36](https://github.com/profoundry-us/loco_motion/issues/36))
- feat: Updated component documentation to use `@loco_example` tag for better organization

## [0.4.0] - 2025-03-07

This version is a major milestone as it finishes out a basic version of all of
the DaisyUI 4 components!

While this gives us a solid foundation to start using the components, we feel
that our time will best be spent upgrading the configuration and components to
utilize the new DaisyUI 5 framework that was recently released.

We will be migrating to the new version and all bug fixes / improvements will be
made in a new LocoMotion 0.5.0 branch / release.

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
