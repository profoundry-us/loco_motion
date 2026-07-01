# Changelog

All notable changes to LocoMotion will be documented in this file.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
_mostly_ adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

We say mostly because all versions before 1.0.0 will likely have breaking changes as we don't consider the
project "released" until that point in time.

We plan to use patch versions only for bug fixes, and for now, all **minor releases** should be considered
**breaking**!

## [Unreleased]

### General Changes

- docs(Icons): Fix the Loco Icons page's "Other Libraries" section and its bundled-icons claim. The section's
  fenced markdown code blocks collapsed into inline code (the HAML `:markdown` filter's Redcarpet lacks the
  `fenced_code_blocks` extension) — rewritten with the demo's `doc_code` / `daisy_code` components. The page
  intro claimed LocoMotion "bundles Heroicons out of the box"; it now says only a small, curated set is
  bundled and links to the `Loco::IconComponent` API docs, whose class docs now enumerate the exact bundled
  set (10 icons × 4 variants).

- fix(Demo): Lay out the "Theme Radio with Inline Preview" example as a row. The radio's `end` slot wraps its
  content in a plain `<div>` (the `BasicComponent` slot wrapper), so the block-level theme preview stacked
  above the theme name instead of flowing beside it — the example had rendered this way since it was added.
  Fixed by styling the slot wrapper via `with_end(css: "flex items-center gap-2")`; the matching
  `build_radio_input` YARD example gets the same fix, and the demo text now calls out the `css:` on
  `with_end`.

- feat(Checkbox): Emit a companion hidden field like Rails' `check_box`. A named, enabled
  `daisy_checkbox` / `daisy_toggle` now renders `<input type="hidden" name="..." value="0">` just before the
  checkbox, so an unchecked box still submits a value — no more hand-rolled `hidden_field_tag` pairs beside
  every toggle. Two new options mirror Rails: `include_hidden` (default `true`; pass `false` to opt out) and
  `unchecked_value` (default `"0"`). The hidden field is skipped for unnamed or disabled inputs, and works
  through the form builder (`f.daisy_checkbox` / `f.daisy_toggle`) automatically. **Breaking-ish:** the
  rendered output of existing named checkboxes/toggles gains a hidden input. Fixes #201.

- docs(Modal): Add a "Blurred Backdrop" example — pass a stock Tailwind utility via the modal's existing
  `backdrop_css` option (`backdrop_css: "backdrop-blur-sm"`) to frost the page behind an open modal. Added to
  the component's YARD examples and the demo page, with a note on Tailwind v4 sizing (there is no bare
  `backdrop-blur`; use `backdrop-blur-xs` ~4px, `-sm` ~8px, `-md` ~12px). Also reworded the `backdrop` part
  docs to point at `backdrop_css` as the styling hook. Fixes #212.

- feat(Icons): The treeshaking scanner (`loco_motion:icons:sync`) now also discovers **symbol** icon names —
  `loco_icon(:bell)`, `icon: :star` — not just string literals, so a symbol-named icon is no longer silently
  dropped from the vendored set. (Bare Ruby symbols can't hold hyphens, slashes, or colons, so hyphenated /
  qualified token names still need strings.)
- docs(Icons): Reword the remaining component param docs that described `icon:` options as "the Heroicon name"
  / "Uses the Heroicon system" to reflect the pluggable `loco_icon` engine — icons resolve from any synced
  library, not just Heroicons (Alert, Avatar, Stat, TimelineEvent, ThemeController, Button).

- docs(Icons): Update the YARD `@loco_example` blocks across the DaisyUI components to use `loco_icon` instead
  of the removed `hero_icon` / `heroicon` helper (31 examples in 18 components). Translates the old
  `rails_heroicon` `size:` / `class:` options to `loco_icon`'s `css:` (e.g. `size: 5` becomes
  `css: "size-5 …"`). Documentation only — no behavior change.

- refactor(Icons): Drop the `rails_heroicon` dependency. LocoMotion no longer bundles `rails_heroicon` or
  exposes the `hero_icon` / `heroicon` helpers — every icon now renders through the `loco_icon` engine.
  Removes the gem (runtime and dev), its `require`s, and the `RailsHeroicon::Helper` include from
  `BaseComponent`. **Breaking:** replace `hero_icon("name")` / `heroicon("name")` with `loco_icon("name")` and
  sync your icons (`bin/rails loco_motion:icons:add heroicons`). See the "Migrating to the Icon Engine" guide.

- refactor(Icons): Drop the `variant:` and `library:` options from `loco_icon` / `Loco::IconComponent`. Encode
  the library/variant in the token instead — `loco_icon("bolt/solid")`, `loco_icon("lucide:heart")`,
  `loco_icon("phosphor:gear/bold")`. The token is the one form the treeshaking sync can scan, so this keeps
  `loco_motion:icons:sync` reliable. Passing either option now raises an `ArgumentError` pointing at the token
  form. **Breaking:** convert any `loco_icon(name, variant:/library:)` calls to tokens.
- feat(Icons): Expand the icon set bundled inside the engine so more components work with zero setup. Adds the
  standard Alert icons (`information-circle`, `check-circle`, `exclamation-triangle`, `exclamation-circle`)
  and the ThemeController's `swatch` alongside the existing chrome set (`x-mark`, `check`, `trash`, the Cally
  chevrons).
- docs(Icons): Add a "Migrating to the Icon Engine" guide covering the move off `rails_heroicon` — syncing
  icons, renaming `hero_icon` → `loco_icon`, replacing `Hero::IconComponent`, component `icon:` options, and
  the `library:name/variant` token grammar. Icon examples use the token grammar throughout (it's what the
  treeshaking sync can scan). Also correct the Install guide's Icons section, which still claimed component
  icons render "with no extra setup" — only the bundled set does; other icons need a one-time sync.
- refactor(Icons): Remove the `Hero::IconComponent` wrapper. It was a thin ViewComponent around the
  `hero_icon` helper that predated the `loco_icon` engine; `loco_icon` (and its `daisy_*` component options)
  now cover every use. Drops the component, its registry entry, the `Hero` module, and the demo's
  `Hero::IconComponent` example page. **Breaking:** replace `Hero::IconComponent` usage with
  `loco_icon("name")`. The `hero_icon` helper itself is unchanged here and removed in a follow-up.
- refactor(Demo): Point the sidebar's icon-docs nav entry at the `Loco::IconComponent` examples page under a
  new "Loco" section, instead of the retiring `Hero::IconComponent` page. The `Loco::IconComponent` docs were
  previously reachable only by direct URL; the `Hero::IconComponent` page and its component are removed in a
  follow-up.
- refactor(Icons): Route managed component icons through the `loco_icon` engine instead of `rails_heroicon`.
  Every component option that takes an icon name (`icon:` / `left_icon:` / `right_icon:`, and the Timeline
  event's `middle_icon`) now resolves like every other library — from the icons synced into your app's
  `app/assets/svg/icons`, falling back to the small chrome set bundled in the engine. **Breaking:** apps that
  use Heroicons in component options must sync them once (`bin/rails loco_motion:icons:add heroicons`, then
  `loco_motion:icons:sync` to treeshake). The `hero_icon` helper and `Hero::IconComponent` are unchanged for
  now and still render the full Heroicons set without a sync.
- feat(Linkable): Add first-class `turbo_frame`, `turbo_method`, and `turbo_confirm` options to every linkable
  component (anything that already takes `href:` — buttons, links, cards, badges, etc.). They map to the
  `data-turbo-frame` / `data-turbo-method` / `data-turbo-confirm` attributes, so common Turbo patterns no
  longer need a hand-written `html: { data: { … } }` hash — `daisy_button("Delete", href: thing_path,
  turbo_method: :delete, turbo_confirm: "Are you sure?")` instead. Implemented as a small `TurboableComponent`
  concern that `LinkableComponent` pulls in, mirroring how `TippableComponent` sugars `tip` over `data-tip`;
  each attribute is emitted only when provided, and an explicit `html: { data: { … } }` value still wins.
  Fixes #202.
- docs(Guides): Add an "install Just" step to the Docker guide's Initial Setup. The guide jumped straight to
  `just dev` without ever telling a brand-new user to install the command runner on their host, so following
  it literally hit `command not found: just`. It now points at `brew install just` / the upstream install
  instructions right after the Docker install.
- chore(Examples): Document the `redis` service in `examples/docker-compose.yml`. It was undocumented, so
  it read as an unexplained loose end; it now carries comments explaining that it's an opt-in convenience
  for caching / Action Cable / background jobs, how to wire it up (uncomment `- redis` under the `app`
  service's `depends_on`), and that it's safe to delete if unused.
- Added publishing auth pre-checks and a Retry / Skip / Abort loop to `bin/release` — before each publish
  the wizard now verifies credentials (`npm whoami` for NPM, a readable `~/.gem/credentials` for RubyGems)
  and, when a pre-check or publish fails, prints the fix (`npm login` / `gem signin`) and re-prompts so you
  can fix credentials in another terminal and retry without restarting the wizard. The same checks run as
  early non-fatal warnings in the prerequisites step, and the dry-run output describes the new behavior.
- fix(Release): In `bin/release`, simplify the release-push step to require running from `main`. Releases
  run directly on `main`, so the step now just pushes `origin main` and confirms success — the push lands
  the commits and there is no PR to open or merge. It errors out if you are not on `main`. This replaces the
  old flow that printed a nonsensical `main...main` self-compare URL and blocked on a "Have you merged the
  PR?" gate even though the commits had already been pushed.
- feat(Release): Automate the CHANGELOG finalization step in `bin/release` — the wizard now replaces the
  `## [Unreleased]` heading with `## [VERSION] - YYYY-MM-DD` itself and shows the resulting diff before the
  existing commit confirmation, instead of opening `$EDITOR` for a manual edit. It skips with an INFO message
  when the version section already exists and falls back to offering `$EDITOR` when there is no
  `[Unreleased]` section. The prerequisites step now verifies `CHANGELOG.md` exists up front so the update
  step can assume it.
- chore(Dev): Add `bin/setup-docker` to bootstrap the Docker-based `just` workflow in remote / cloud Claude
  Code sessions. It starts the Docker daemon with a `mirror.gcr.io` pull-through cache (so anonymous Docker
  Hub pulls avoid the HTTP 429 rate limit), installs `just`, bakes the environment's egress-proxy CAs and
  `NODE_EXTRA_CA_CERTS` into a local `ruby:3.4.4` base so in-container HTTPS verifies, then builds and starts
  the `loco` and `demo` containers. Idempotent and a no-op locally; documented in `CLAUDE.md`.
- chore(Release): Keep the documented `gem "loco_motion-rails", "~> X.Y.Z"` install pins in sync with the
  released version. `bin/update_version` now rewrites the pins in `README.md` and the Install guide when it
  bumps the version, and `bin/version-check` (`just version-check`) verifies those two pins alongside
  `version.rb` / `VERSION` / the npm packages — so a stale pin (which silently excludes the new release, like
  `~> 0.5.2` excluding 0.6.0) fails the check instead of shipping.
- feat(CSS): Ship an importable LocoMotion CSS file — the CSS peer of the npm package's JS controllers —
  collecting the custom variants (`where`, `dark`) and component-required utility rules (the `floating-sticky`
  label helper and the keyboard-focus tooltip reveal) that components depend on. Consumers now
  `@import '@profoundry-us/loco_motion/loco.css'` once instead of hand-copying a growing `@custom-variant`
  block out of the Install guide, so they stay in sync across upgrades. The file lives at
  `app/assets/stylesheets/loco.css` (so it ships in the gem automatically) and is exposed to npm through a new
  `exports` map plus the `files` list; `@import 'tailwindcss'`, the `daisyui` plugin, and `@config` stay in
  the consumer's own entry since they are app-level choices. The Install and Getting Started guides now point
  at the import, and the demo consumes the shared file instead of duplicating the rules. Fixes #170.
- chore(Examples): Refresh the `examples/` scaffolding that new projects copy from the Docker guide. The
  `examples/Dockerfile` and `examples/dev/Dockerfile` now use the same official `ruby:3.4.4` base plus a
  manual Node 20 install as LocoMotion's own containers, instead of the outdated `timbru31/ruby-node:3.3-*`
  images (which also disagreed on Node 18 vs 20 between files). Removed the orphaned `examples/Makefile` (a
  leftover from before the Make→Just migration that the guide never referenced), dropped the conflicting
  `image:` line on the compose `dev` service, fixed the `db-dev` / `db-test` recipes to use
  `app_development` / `app_test`
  (they pointed at a stray `trc_*` database), renamed `app-rspec` to `app-test` for consistency, and added
  `build`, `rebuild`, `test`, `lint`, and `lint-fix` recipes. Also removed the dead `db-shell` / `db-dev` /
  `db-test` recipes from the repo's own `justfile` — there is no `db` service and the demo uses SQLite.

### Components Changes

- refactor(Icons): Render Cally's month-navigation chevrons through the `loco_icon` engine instead of
  `rails_heroicon`. `chevron-left` / `chevron-right` join `x-mark` / `check` / `trash` in the icons bundled
  inside the gem, so the calendar's prev/next arrows still render with zero consumer setup. Non-breaking
  groundwork for removing `rails_heroicon`. Refs #204.
- fix(Icons): `loco_motion:icons:sync` no longer crashes when `config.icon_safelist` is set.
  `LocoMotion::Icons::Reference.parse` now always returns a String `library`, so scanned references (already
  strings) and safelist references share one type — previously a `:heroicons` default mixed with the
  `"heroicons"` scanned values, which neither deduped nor sorted (`comparison of String with Symbol failed`).
  Refs #204.
- feat(Icons): Add a local icon cache so treeshaking is fast and offline. A new `loco_motion:icons:cache`
  task downloads the full libraries you reference into `config.icon_cache_path` (default
  `tmp/loco_motion/icons`, which Rails already gitignores), and `loco_motion:icons:sync` now copies the used
  icons from that cache instead of re-cloning every run — so once the cache is warm, adding a new icon is a
  fast, offline file copy rather than a network sync. `sync` auto-downloads any referenced library that
  isn't cached yet, so the first run still works. **In development the renderer also falls back to the
  cache**, so a freshly-used icon renders on the next refresh without re-running `sync` — while test and
  production read only the committed `app/assets/svg/icons`, keeping the treeshaken set the source of truth.
  The Install guide documents the cache → sync flow and a git pre-commit hook that keeps the committed set
  in step with usage. Refs #204.
- fix(Icons): Re-syncing an already-vendored library now actually refreshes it. `Installer.add` clears each
  library's target directory before syncing, working around the `icons` gem's move silently no-opping when
  the destination exists — so re-running `loco_motion:icons:add` (or refreshing the cache) updates the SVGs
  instead of doing nothing. Refs #204.
- feat(Icons): Support qualified icon tokens — `[library:]name[/variant]` (e.g. `loco_icon("lucide:heart")`,
  `loco_icon("phosphor:gear/bold")`, `daisy_button(icon: "bolt/solid")`). The library and variant now travel
  inside the icon string itself (Iconify-style), so a reference is self-contained; anything the token
  specifies overrides the `library:` / `variant:` arguments, which remain as fallbacks. A single
  `LocoMotion::Icons::Reference` parser backs the renderer, the safelist, and the scanner below.
- feat(Icons): Add deterministic icon treeshaking — a `loco_motion:icons:sync` rake task that scans your app
  for icon usage and vendors only the icons you actually use, the icon analogue of Tailwind scanning
  templates for class names. It reads `config.icon_content_paths` (default `app/**/*.{rb,erb,haml,slim}`),
  statically extracts the qualified tokens from `loco_icon` / `hero_icon` calls and the universal `icon:` /
  `left_icon:` / `right_icon:` options, then vendors that set into `app/assets/svg/icons`, pruning unused
  icons. It's a pure regex scan (no code evaluation), so the same source always yields the same set — and
  because each token is self-contained, the scan never has to guess a library / variant from another line.
  Dynamically-named icons it can't see statically (`loco_icon("bars-#{n}")`) go in `config.icon_safelist`
  (also qualified tokens) — the analogue of Tailwind's safelist. Backed by new
  `LocoMotion::Icons::Scanner` and `LocoMotion::Icons::Vendorer` classes. Refs #204.
- refactor(Icons): Render the built-in component chrome icons through the `loco_icon` engine instead of the
  `hero_icon` / `heroicon` (rails_heroicon) helpers — the Alert and Modal close buttons (`x-mark`) and the
  ThemeController menu's check / trash icons. These all use icons bundled inside the gem, so they render with
  zero setup and no icon sync, and the output is visually unchanged. This removes the internal chrome's
  dependency on `rails_heroicon` ahead of its removal. Refs #204.
- feat(Icons): Teach the universal icon options (`icon:` / `left_icon:` / `right_icon:` on every component)
  about icon libraries and variants. Their value is a qualified `[library:]name[/variant]` token, so any
  component can render an icon from a synced library or a non-default variant, e.g.
  `daisy_button(icon: "phosphor:trash/bold")`. The library and variant default to
  `LocoMotion.configuration.default_icon_library` / `default_icon_variant`. The default Heroicons library
  still renders through `rails_heroicon`, so existing usage is unchanged and needs no icon sync. Other
  libraries render through the `loco_icon` engine (resolved from the app's `app/assets/svg/icons`). Refs #204.
- refactor(Icons): The Dock section's `icon_variant:` option is likewise replaced by the qualified token —
  `dock.with_section(icon: "home/solid")` instead of `icon: "home", icon_variant: :solid`. Refs #204.
- feat(Icons): Add a pluggable icon engine and a new `loco_icon` helper (`Loco::IconComponent`) that renders
  inline SVG from any installed icon library. To keep the gem lean, LocoMotion bundles only a handful of
  icons; consumers install the full Heroicons set — or any other library (Lucide, Phosphor, Tabler, brand
  sets, …) — by running `bin/rails generate loco_motion:install` (or `loco_motion:icons:add <library>`),
  which syncs the SVGs into their own `app/assets/svg/icons` (a `post_install_message` advertises this).
  Resolution is two-tier — the app's `app/assets/svg/icons` is checked first, then the bundled set — and
  SVGs are parsed in XML mode so `viewBox` and other case-sensitive attributes stay valid. The helper mirrors
  `hero_icon` (the `where:size-5` default, `css:`, `tip:`) and adds `library:` / `variant:`; the per-call
  defaults come from `LocoMotion.configuration.default_icon_library` / `default_icon_variant`, so an app can
  make any synced library its default. Built on the framework-agnostic `icons` gem (keeps Rails 6.1). Added
  alongside the existing `hero_icon`, which is unchanged for now. Refs #204.
  images no longer shift height as each image is revealed on hover. The default uses DaisyUI's
  zero-specificity `where:aspect-[3/2]` and is skipped when you pass your own `aspect-*` utility via `css:`,
  so it stays easy to override. The demo examples drop their now-redundant explicit `aspect-[3/2]`.
- feat(Modal): Add a `trigger: false` option that renders a "Global Modal" — just the `<dialog>` with no
  built-in trigger button — so one modal can live in a layout and be opened from anywhere on the page (a
  link, another component, or JavaScript). Also lets a call-time `html: { tabindex: -1 }` on the activator
  override the default `tabindex="0"`, which the build-time default previously clobbered. Refs #161.
- feat(Modal): Add an optional `loco-modal` Stimulus controller that opens and closes the `<dialog>` from
  JavaScript (`loco-modal#open` / `loco-modal#close`) and dispatches bubbling `loco-modal:open` /
  `loco-modal:close` lifecycle events. The controller re-dispatches the dialog's non-bubbling native `close`
  event, so `loco-modal:close` fires for every close (Escape, backdrop, a `<form method="dialog">` submit, or
  the `close` action). It is attached to every modal automatically but stays inert until an app registers it,
  so existing modals are unaffected. Refs #161, #16.
- feat(Modal): Add a `turbo_frame_id:` option that renders an empty `<turbo-frame>` inside the modal and wires
  the `loco-modal` controller to open the dialog when that frame loads (and clear it on close). Combined with
  `trigger: false` this delivers the canonical Hotwire "Global Modal" pattern: one modal in your layout,
  opened by pointing `data-turbo-frame` links at the frame id — no per-row modals or inline JavaScript.
  Refs #161, #16.
- fix(Select): Honor the select's `value:` when options are defined with the block form
  (`select.with_option`). Previously only the `options:` array form preselected the matching option; block
  options always rendered unselected unless you passed `selected:` on every one — so form-builder edit forms
  (`f.daisy_select :branch_id`) showed the first option instead of the record's saved value. Block options now
  default their selected state from the parent `value:`, and an explicit `selected:` on an option still wins.
  Fixes #171.
- feat(ThemeController): The `loco-theme` controller's `getCurrentTheme` now falls back to the document's
  applied `data-theme` when nothing is saved in `localStorage`, so `setInput` marks the active row/checkmark
  on first visit (e.g. a server-rendered or preload-applied theme) instead of leaving every option unmarked
  until the user picks one. Saved choices still win. Refs #165.
- feat(ThemeController): `build_radio_input` now forwards a block to the underlying radio, so you can fill the
  radio's `start` / `end` slots — e.g. drop a theme preview swatch and label inside the radio's own label so
  the whole row is one clickable control, instead of a separate wrapping `<label>` plus a `hidden peer` radio.
  Refs #165.
- feat(Dropdown): Give `with_item` a structured builder for selectable menu rows. Pass `label:`, `href:`, and
  `selected:` and use the item's `start` / `end` slots (matching our other components), and the dropdown
  renders a proper `<li class="menu-item"><a class="… menu-active">` row instead of making you hand-roll the
  markup. Bare content-block items (`with_item do … end`) render exactly as before, so this is fully backward
  compatible. Refs #165.
- feat(Fieldset): Add a caption / helper-text slot to `daisy_fieldset`. Provide it with the `caption` slot
  (`fieldset.with_caption`) or the `caption:` argument, and it renders below the controls using DaisyUI's
  `.fieldset-label`. Unlike `.label` (`daisy_label`), `.fieldset-label` is not `white-space: nowrap`, so long
  help text wraps instead of pushing the form off-screen. `.fieldset-label` is `display: flex`; for prose with
  an inline link, pass `caption_css: "block"` so the link flows inside the sentence. Fixes #162.
- feat(ThemeController): Add a `build_switcher_dropdown` builder that renders a complete, working theme
  switcher in one line — a trigger button plus a menu with a color preview, name, and an active checkmark for
  every theme, all wired to the `loco-theme` controller. Supports `label:`, `icon:`, `clear:` (a "Clear Theme"
  row), `name:`, and a `css:` placement. It's a builder method on the existing component (composing
  `build_radio_input` and `build_theme_preview`), not a new component or subclass. Fixes #165.
- fix(Alert): Stop the close button on a `closable` alert from overlapping the message text. The ✕ reserved
  room with a zero-specificity `where:pr-10` rule that lost the cascade to DaisyUI's `.alert` padding, so no
  space was actually reserved and the button rode the message. It is now pinned to the alert's top-right
  corner (`where:absolute where:top-2 where:right-2`) so it is always right-aligned and stays at the top of
  tall, multi-line alerts, and the reserved `pr-10` is now a plain (non-`where`) utility that wins the cascade,
  so the message never slides under it. Fixes #186.
- fix(Iconable): Stop icons from being squished next to long content. `IconableComponent` lays components out
  as an `inline-flex` row, so an icon (a flex item with the default `flex-shrink: 1`) shrank horizontally when
  the adjacent text was long — e.g. a multi-line `daisy_alert`'s leading icon collapsed to roughly half its
  width while its height stayed fixed. Icons rendered through the concern now default to `where:shrink-0`
  (prepended, so an explicit `shrink`/`grow` via `icon_css` still wins), keeping them at their intended size
  across every icon-bearing component (Alert, Button, Badge, etc.).

### Demo / Docs Changes

- refactor(Demo): Adopt the icon engine across the demo and dogfood treeshaking. Renamed every direct
  `hero_icon` / `heroicon` call to `loco_icon` (chrome, the `doc_*` helper components, and example pages),
  expressing variant / library choices as qualified `[library:]name[/variant]` tokens (e.g.
  `loco_icon("bolt/solid")`, breadcrumb / menu `*/mini`) so the scanner sees them. Added a demo
  `config.icon_safelist` for the dynamically-named icons (the `doc_note` modifier defaults, `doc_info`'s
  default, the `bars-2/3/4` tabs loop, the breadcrumb `*/mini` icons), then ran `loco_motion:icons:sync` to
  vendor only the icons the demo uses (~91 SVGs across the four Heroicon variants) into
  `docs/demo/app/assets/svg/icons`. Verified every icon page renders from the committed set alone (dev cache
  disabled). The universal `icon:` options still render via `rails_heroicon` until that is removed; this
  commits the set they will resolve from. Refs #204.
- docs(Install): Add an "Icons" section to the Install guide. It explains that every component's `icon:`
  options render Heroicons with zero setup, introduces the standalone `loco_icon` helper, and documents the
  `loco_motion:icons:add` / `loco_motion:icons:list` tooling for syncing the full Heroicon set or other
  libraries (Lucide, Phosphor, Tabler, …) into the app, plus the `default_icon_library` /
  `default_icon_variant` configuration. Notes that `git` is required to sync. Refs #204.
- fix(Demo): Fix the "Link with Icon" button on the Buttons example, which showed no icon. It passed `icon:`
  together with a content block, but a `daisy_button` block replaces the managed icon + title layout by
  design (the block is yours to fill), so the icon was dropped. Switched the example to the title form
  (`daisy_button("Link with Icon", …, icon: "arrow-right")`) like the other icon buttons on the page.
- fix(Demo): Fix the broken 3D tilt in the Hover 3D "3D Hover Image Gallery" example. The wrapper passed a
  `block` display utility, which overrode DaisyUI's `display: inline-grid` on `.hover-3d` and collapsed the
  eight hover zones that drive the tilt, so cards only scaled instead of rotating. Dropped `block` so the
  grid (and the tilt) survive — the cards already lay out correctly as flex items without it.
- fix(Demo): Stop the Hover Gallery examples from jumping in height while hovering. The sample landscape
  images have different aspect ratios, and DaisyUI leaves the gallery container at `height: auto`, so the
  rendered height (and everything below it) shifted as each image became visible. Added `aspect-[3/2]` to
  every `daisy_hover_gallery` wrapper so the height depends only on the width and `object-cover` crops each
  image to fill the fixed box.
- fix(Demo): Keep the FAB demo examples inside their own preview boxes. A FAB is `position: fixed`, so with
  five on one page they all escaped to the viewport's bottom-right corner and their preview boxes collapsed
  to 0px. Wrapped each example in a `relative` box with a fixed height (`h-48`) and a `[&_.fab]:absolute`
  override so each FAB sits in the bottom-right of its own box; documented why on the demo page intro.
- docs(Hover): Document that passing a `display` utility (`block`, `flex`) via `css:` overrides the
  `hover-3d` effect's `display: inline-grid` and breaks the 3D tilt. Added a `@note` to the component's
  YARD docs and a callout to the demo page intro, and corrected the YARD "Image Gallery" example that still
  used `block`.
- docs(Guides): Reconcile overlap between the Install, Getting Started, and Docker guides left over from
  folding the README in. The Docker guide is now scoped to environment setup only (install Docker, copy the
  config files, `just dev` / `just dev-shell`) and ends by pointing at Getting Started, which owns the
  app-creation flow (`rails new`, database config, running the app). The duplicated Tailwind 4 + DaisyUI CSS
  block was removed from Getting Started, which now links to the Install guide as the canonical source.
- docs(Install): Refresh the install instructions for v0.6.0. Bumped the stale `~> 0.5.2` gem pin (which
  excluded 0.6.0) to `~> 0.6.0` in the README and the Install guide, refreshed the README's "v0.5.x" status
  note and the `CLAUDE.md` version reference, and trimmed the README's duplicated install walkthrough to a
  quickstart that points at the Install guide as the canonical source (the `bundle show` gotcha moved into
  that guide).
- docs(Button): Document `ButtonComponent`'s `action:` parameter, which attaches a Stimulus action via the
  button's `data-action` attribute. Added the missing `@option action` entry to the `initialize` YARD (noting
  that Stimulus infers the `click` event for buttons, so `action: "my-controller#handle"` is shorthand for
  `action: "click->my-controller#handle"`) plus a "Stimulus Action" `@loco_example`. The parameter already
  worked and was spec-covered, but was previously undocumented.
- docs(Install): Document registering the `loco-modal` controller in the install guide, and update the
  Modals demo's "Global Modal" example to close via the `loco-modal#close` action and surface its
  `loco-modal:close` lifecycle event.
- docs(Modal): Add a "Global Modal (Turbo Frame)" demo example — a contact list whose edit links stream an
  edit form into one shared modal via a `<turbo-frame>` — backed by a small demo-only `ModalContacts`
  controller, plus a Turbo Frame `@loco_example` and `@option turbo_frame_id` in the component's YARD.
- docs(Demo): Update the Selects "Pre-Selected Value" example to preselect through the select's `value:`
  attribute (now honored for block options) instead of a per-option `selected:`, matching what the example's
  description already described.
- feat(Demo): Add a `floating-sticky` CSS variant that pins a DaisyUI floating label in its raised position
  even while the field is empty and showing a placeholder, so the label and the placeholder hint show at once
  (a Material-style label). Opt in by adding it to the label wrapper, e.g. `daisy_text_input(floating:
  "Email", placeholder: "you@example.com", label_wrapper_css: "floating-sticky")`. The rule now ships in the
  importable LocoMotion CSS file (see the General Changes entry for #170). Added a "Sticky Floating Label" demo
  example and a Playwright check that the label stays raised. Fixes #169.
- docs(ThemeController): Add a "Theme Radio with Inline Preview" demo example demonstrating the new
  `build_radio_input` block form (preview + label inside the radio's own label).
- docs(Dropdown): Add a "Selectable Items" demo example using the new structured `with_item` builder
  (`start` icon, label, `end` checkmark, and a `selected` active row).
- docs(Fieldset): Add two Fieldsets demo examples for the new caption slot — one using the `caption:` argument
  and one using the `caption` slot with `css: "block"` for a caption containing an inline link — plus a smoke
  check for both in the Playwright spec.
- docs(ThemeController): Add a "Switcher Dropdown (Builder)" demo example showing `build_switcher_dropdown`
  (plain, and with a label + Clear Theme row), plus a Playwright test that picking a theme applies, persists,
  and marks the active row.
- docs(ThemePreview): Fix `ThemePreviewComponent`'s YARD examples, which advertised a `daisy_theme_preview`
  helper that was never registered. They now show the real usage — `tc.build_theme_preview` inside a
  `daisy_theme_controller`, or rendering the component directly — plus a `@note` that there is no top-level
  helper. (Follows the decision in #176 not to ship a standalone preview helper.)
- docs(Toast): Fix `ToastComponent`'s misleading `@note`, which promised toast show/hide in a "future Stimulus
  ToastController". Dismissal already ships via the Alert component's `loco-alert` controller, so the note now
  points at the Alert's `autoclose` / `closable` options (and the required `AlertController` registration), and
  a new "Auto-dismissing, Closable Toast" `@loco_example` makes that path discoverable. Fixes #185.
- docs(Iconable): Document the previously-undocumented `icon_options` / `left_icon_options` /
  `right_icon_options` parameters on icon-bearing components (Alert, Button, Badge, etc.). These forward
  options to the underlying `Hero::IconComponent` constructor — most notably `variant: :outline` /
  `variant: :solid` to pick the icon style — and are distinct from `icon_html`, which sets HTML
  attributes on the `<svg>`. `icon_options` is the intended way to set icon component options.

### Fixed

- fix(Demo): Drop `vendor` from the demo app's Rails load path to stop the intermittent `SystemStackError`
  that crashed the Playwright CI job's production server boot. Rails adds `vendor` to `$LOAD_PATH` by default,
  but ours holds only the `loco_motion-rails` symlink, which points back at the repo root and so makes
  `vendor` a self-referential directory cycle (`vendor/loco_motion-rails` -> repo ->
  `docs/demo/vendor/loco_motion-rails` -> ...). Bootsnap's path scanner follows symlinks with no cycle
  detection, recursing until the call stack overflowed — whether it overflowed or merely wasted time depended
  on the runner's stack size and path length, hence the flakiness. Bundler already loads the gem through its
  own `lib`/`app` require paths, so nothing requireable lives in `vendor` and skipping it is safe.

## [0.6.0] - 2026-06-12

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
- fix(Release): In `bin/release`, always run the version-update step even when a version is passed as a
  CLI argument (previously `bin/release 0.6.0` skipped `just version-set` and `just loco-version-lock`,
  releasing stale artifacts), and fix the checklist auto-check `gsub!` patterns that used regex escapes
  inside plain strings and therefore never matched any checkbox lines.
- fix(Release): Anchor the `create-checklist` placeholder `sed` to the `**Release Version**` line so the
  version is no longer stamped into the `**Release Date**` and `**Released By**` footer lines, and set those
  template placeholders to `TBD` (the v0.5.2 checklist ended up with `**Release Date**: 0.5.2`).
- fix(Release): In `bin/update_demo_after_release`, run `just demo-version-lock` instead of the removed
  `make` target — the Makefile no longer exists, so Phase 2 (the demo app update) of every release failed.
- chore(Release): Remove the auto-generated release checklist machinery — the `create-checklist` justfile
  target (and its calls in `version-bump`/`version-set`), the checklist-stamping step in `bin/release`, and
  `docs/templates/release_checklist.md`. The interactive `bin/release` wizard and `RELEASING.md` are now the
  single source of truth for the release process.
- fix(Release): Read interactive prompts from `$stdin` in `bin/release` and
  `bin/update_demo_after_release` — bare `gets` reads from `ARGF`, so with a version argument the first
  prompt crashed trying to open a file named after the version (e.g. `0.6.0`).
- fix(Release): Point the `bin/release` llms.txt commit step at the actual generated files
  (`docs/demo/public/llms*.txt`) instead of the repo-root `llms.txt`/`llms-full.txt` — the v0.6.0 release
  failed with `fatal: pathspec 'llms.txt' did not match any files` — and include `docs/demo/Gemfile.lock`,
  which `just llm` can dirty by refreshing the demo container's bundle stamp. Also fix the `LLM*.txt`
  filename casing in `RELEASING.md` (the generated files are lowercase `llms*.txt`).

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
- fix(demo): Stop exposing the write-capable Algolia API key to the browser — `algolia_credentials_tag` now
  injects a new search-only `ALGOLIA_SEARCH_API_KEY`, while `ALGOLIA_API_KEY` (write access) stays
  server-side for the indexing rake tasks and Heroku release phase
- docs(Algolia): Document the write/search API key split in `docs/dev_guides/ALGOLIA.md` and pass the new
  search key through the Playwright CI workflow

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
