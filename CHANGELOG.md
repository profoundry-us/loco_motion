# Changelog

All notable changes to LocoMotion will be documented in this file.

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
