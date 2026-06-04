# Plan: Architecture & Standards Review

## Overview

This plan captures the findings of a full-codebase review of LocoMotion
(v0.5.2) conducted from the perspective of a senior Rails consultant brought in
to "set better standards and fix architecture issues." It is a **recommendations
roadmap**, not a single refactor — it organizes the findings into prioritized
workstreams so they can be shipped as a series of small, focused PRs.

The goal is to convert hand-policed conventions into **enforced** standards,
remove the highest-risk tech debt in the core, and close consistency gaps across
the 68 components — without changing the public component API or adding any
DaisyUI variant parameters (see CLAUDE.md).

### How this review was conducted

Six parallel reviews covered, respectively: the core library (`lib/loco_motion`),
the component classes/templates (`app/components/daisy`), the test strategy
(`spec/` + demo + Playwright), documentation/YARD/README, build/tooling/release,
and the JavaScript/Stimulus + demo-app layers. Findings below cite specific
`file:line` evidence and a severity (High / Medium / Low).

### Guiding principle

LocoMotion already has strong, well-written conventions (CLAUDE.md,
`.windsurf/rules/`) and the authors clearly understand the subtle hazards (the
`class_attribute` mutation trap is commented three times). The single biggest
structural gap is that **none of these standards are automatically enforced** —
there is no Ruby linter, no `frozen_string_literal` consistency, no
multi-version CI, and several conventions are documented in three places that
can drift. The plan therefore front-loads enforcement infrastructure so later
cleanup stays clean.


## External Resources

- [GitHub #73 — Refactor README into Guides](https://github.com/profoundry-us/loco_motion/issues/73)
- [GitHub #41 — Investigate new Popover API](https://github.com/profoundry-us/loco_motion/issues/41)
- [GitHub #35 — DaisyUI 5 Validator / form validations](https://github.com/profoundry-us/loco_motion/issues/35)
- [GitHub #16 — Modal should use a Stimulus controller](https://github.com/profoundry-us/loco_motion/issues/16)
- [ViewComponent docs](https://viewcomponent.org/)
- [StandardRB](https://github.com/standardrb/standard) /
  [RuboCop](https://docs.rubocop.org/)


## Recommended Sequencing

1. **Tier 1 — Correctness bugs.** Small, high-value PRs. Ship first.
2. **Tier 2 — Standards enforcement.** Lint + CI + version single-source. Do
   this before the large cleanups so they land already-conformant.
3. **Tier 3 — Core architecture hardening.** The `build` rewrite and the
   ViewComponent patch safety net.
4. **Tier 4 — Component consistency.** Concern extraction and convention
   normalization across the 68 components.
5. **Tier 5 — Testing strategy.** Shared passthrough example + coverage fills.
6. **Tier 6 — Documentation & meta-docs.** README split (#73), meta-doc fixes.

Each tier is independent enough to be tackled on its own branch. Tiers 1, 2, and
6 deliver value immediately; Tiers 3–5 are larger and can be scheduled over
several releases.


## Tier 1 — Correctness Bugs

These are confirmed (or near-confirmed) defects, not stylistic debt. Each is a
small standalone PR.

### 1.1 `before_render` overrides drop concern setup hooks (no `super`)

**Severity:** High

`BaseComponent#before_render` is what runs the concern setup hooks
(`component_setups`) — this is how `IconableComponent`, `TippableComponent`,
`AriableComponent`, etc. apply their CSS/attributes. Several components override
`before_render` and call only `setup_component`, never `super`, so those hooks
silently never run.

The clearest active bug is `BreadcrumbItemComponent`, which **includes**
`IconableComponent` and `TippableComponent` (lines 44-45) but whose
`before_render` (line 74) only sets tag names and does **not** call `super` — so
the concern setup hooks (`_setup_iconable_component`, `_setup_tippable_component`)
never run, and `tip:` and icon flex/gap classes are silently ignored on
breadcrumb items. (The parent `BreadcrumbsComponent#before_render` at line 123
also omits `super`, but it includes no concerns, so it is currently harmless —
fix it too to prevent the same latent trap.)

- `app/components/daisy/navigation/breadcrumbs_component.rb:74-79` (active bug)
  and `:123-126` (latent)
- Also audit: `data_input/rating_component.rb:94`,
  `data_display/timeline_event_component.rb:61`,
  `navigation/steps_component.rb:104` + its StepComponent,
  `navigation/dock_component.rb`.

**Fix:** every `before_render` override must call `super` (the
`setup_component; super` / `super; setup_component` pattern). Then add a
regression spec asserting `daisy_breadcrumbs` items honor `tip:` and `icon:`.

### 1.2 README Stimulus integration uses the wrong controller identifiers

**Severity:** High

Every JS-backed component registers a `loco-`-prefixed Stimulus identifier
(`loco-countdown`, `loco-alert`, `loco-theme`, `loco-cally-input` via
`add_stimulus_controller`), but the README's only integration example tells
consumers to `application.register("countdown", CountdownController)`. A
copy-paste of the documented snippet produces a controller that **never
connects** (no targets resolve). The demo's `controllers/index.js` uses the
correct `loco-*` names.

- `README.md:803-813`

**Fix:** correct the README to register all controllers under their `loco-*`
identifiers, and document the exact identifier for every JS-backed component.

### 1.3 `countdown_controller.js` leaks its interval (no `disconnect`)

**Severity:** Medium

`startCountdown()` creates a `setInterval` but the controller defines no
`disconnect()`, so in a Turbo/Hotwire app every navigation away from a page with
a running countdown leaves a 1-second timer running against a detached element
(and revisiting stacks more). The sibling `alert_controller.js` correctly
`clearTimeout`s in `disconnect()`.

- `app/components/daisy/data_display/countdown_controller.js:44-54`

**Fix:** add `disconnect() { clearInterval(this.interval) }`.

### 1.4 Shipped `llms.txt` / `llms-full.txt` are a release behind; download link is broken

**Severity:** High

`docs/demo/public/llms.txt` and `llms-full.txt` are byte-identical to the
`-v0.5.1` copies (header still reads `v0.5.1`) while `VERSION` is `0.5.2`. The
demo's LLMs page links to `/llms-v#{LocoMotion::VERSION}.txt` =
`/llms-v0.5.2.txt`, **which does not exist on disk** — the download is currently
404.

- `docs/demo/public/llms.txt`, `llms-full.txt`

**Fix:** regenerate via `just llm`, and wire regeneration into the release
process so the "latest" pointers can't fall behind (verify the Heroku release
phase runs it, not just `bin/reindex_algolia`).

### 1.5 `theme_controller.js` accesses `localStorage` without guards

**Severity:** Medium

`theme_preload_script` (the helper) carefully wraps `localStorage` in try/catch
for private-browsing mode, but the controller's `applyTheme`, `clearTheme`, and
`getCurrentTheme` call `localStorage` unguarded. In Safari private mode
selecting a theme throws and aborts before `data-theme` is set.

- `app/components/daisy/actions/theme_controller.js:75,132,145`

**Fix:** mirror the helper's guarding (or add a small `safeStorage` wrapper).

### 1.6 Smaller confirmed defects

**Severity:** Low (batch into one cleanup PR)

- **Avatar `<img>` has no `alt`** —
  `app/components/daisy/data_display/avatar_component.rb:91` sets `title:` but not
  `alt:`. Accept/apply an `alt:` option (default to initials/`tip`). Same gap on
  FigureComponent's `:image` part.
- **StepComponent dead accessor** — `navigation/steps_component.rb:49` declares
  `attr_reader :simple` but the ivar is `@simple_title`; the reader returns nil.
- **Iconable copy-paste default** —
  `lib/loco_motion/concerns/iconable_component.rb:58` defaults
  `@left_icon_options` to `@icon_html` (almost certainly should be
  `@icon_options`).
- **`getCurrentTheme` returns `undefined`** —
  `theme_controller.js:144-150` falls off the end despite a `@returns {string}`
  contract; return `null`/default explicitly.


## Tier 2 — Standards Enforcement Infrastructure

This is the highest-leverage tier for the stated goal ("set better standards").
It converts hand-policed rules into automated gates so the rest of the cleanup
stays clean.

### 2.1 Add a Ruby linter/formatter and a CI lint gate

**Severity:** High

There is **no** `.rubocop.yml` / `.standard.yml` and no JS linter config
anywhere. A published gem with strict hand-written style rules (80-col wrap, doc
ordering, blank-line conventions) enforces them only through human/Claude review.

**Fix:** add `standard` (or `rubocop` + `rubocop-rails`) as a dev dependency with
a checked-in config, optionally `prettier`/`eslint` for the Stimulus
controllers, and a `lint` job in CI so PRs fail on violations. Tune the config to
the project's existing conventions rather than reformatting wholesale.

### 2.2 Enforce `# frozen_string_literal: true`

**Severity:** Medium

Nearly every `lib/` file is missing the magic comment (only `version.rb` and
`labelable_component.rb` have it). Add it everywhere and let the linter (2.1)
enforce it going forward.

### 2.3 Single source of truth for the version

**Severity:** Medium

The version is duplicated across four files — `VERSION`,
`lib/loco_motion/version.rb`, `package.json`, `docs/demo/package.json` — kept in
sync only by `bin/update_version`. The top-level `VERSION` file is **read by
nothing** in the gem (it exists only for an external Heroku buildpack) yet is
undocumented, so it reads as dead cruft.

**Fix:** make `version.rb` the source and derive the others at build time, or add
a CI check that fails when the values disagree. Document why `VERSION` exists.

### 2.4 Test the advertised Rails support range

**Severity:** High

The gemspec advertises `rails >= 6.1, < 8.1`, but `Gemfile.lock` resolves
`6.1.7.7` (EOL) and CI runs `rspec` against that single version. The gem claims
7.0/7.1/7.2/8.0 support that is never exercised.

**Fix:** add a CI matrix (Appraisal or per-version `BUNDLE_GEMFILE`) covering at
least 6.1, 7.1, 7.2, and 8.0.

**Status (deferred):** An initial Appraisal-based attempt was reverted. Two
problems make this more than a config tweak and need real verification:

1. **Ruby/Rails compatibility.** The CI runner and the project pin Ruby 3.4,
   but Rails 6.1 and 7.1 fail to boot on Ruby 3.4 (e.g. ActiveSupport's
   `logger_thread_safe_level` patch). A real matrix must pair each Rails
   version with a Ruby it actually supports (e.g. Rails 6.1 → Ruby 3.0/3.1),
   so the matrix needs a Ruby axis too.
2. **Lockfiles.** Hand-written `gemfiles/*.gemfile` without committed
   `.lock`s resolve unpredictably and break `Bundler.require` (the `appraisal`
   gem is loaded at spec boot via `rails_helper.rb`). Run
   `bundle exec appraisal generate` and commit the locks.

Until both are sorted, CI keeps the single locked-version `rspec` job.

### 2.5 Reconcile dev vs runtime Rails constraint

**Severity:** Medium

Runtime allows `rails < 8.1` but the **dev** dependency pins `< 8.0`
(`loco_motion-rails.gemspec:21` vs `:39`) — maintainers literally cannot
reproduce a Rails 8.0 bug locally. Change the dev pin to `< 8.1` (or drop it).

### 2.6 Release automation and `make`→`just` fix

**Severity:** Medium

There is no tag-triggered release workflow; publishing is a 640-line interactive
`bin/release` wizard that depends on local credentials and shells out to `make`
targets — directly contradicting CLAUDE.md's "always use `just`, never `make`."

**Fix:** add a `release.yml` triggered on `v*` tags using RubyGems/npm trusted
publishing (OIDC); update `bin/release` to call `just`.

### 2.7 CI hardening

**Severity:** Low

- Add a `concurrency` group (`cancel-in-progress: true`) so rapid pushes don't
  pile up the expensive Playwright job.
- Make `setup-node` read `.node-version` (`node-version-file`) so CI matches the
  pinned `20.11.1`.
- Enable Dependabot + `bundler-audit`.
- Fix `.gitignore` `.DS_Store` rule (`**/*/.DS_Store` misses root) and delete the
  stray `lib/loco_motion/patches/.DS_Store`.


## Tier 3 — Core Architecture Hardening

### 3.1 Rewrite `BaseComponent.build` on top of `prepend`

**Severity:** High

`build` is the riskiest code in the library:

- It captures `instance_method(:initialize)` and calls
  `original_initialize.bind(self).call(...)` — bypassing normal method
  resolution. This is fragile: the captured `UnboundMethod` goes stale if a
  concern is included afterward, and it interacts non-obviously with components
  that override `initialize` + `super`.
- `@build_counter` is a non-thread-safe read-modify-write used only to mint
  unique class names.
- Every `.build` call creates a never-collected anonymous subclass; safe today
  because all call sites run at class-load time, but `build` is a **public,
  documented** API and any per-request use would leak classes.

- `lib/loco_motion/base_component.rb:215-274`

**Fix:** reimplement via a `prepend`ed module whose `initialize` calls `super`
(traversing the real ancestor chain), drop `@build_counter` in favor of
`SecureRandom`/`object_id`-based names (or memoize built classes by a hash of
their args), and document loudly that `.build` is class-definition-time only.

### 3.2 Make the ViewComponent monkeypatches upgrade-safe

**Severity:** High

`slot_loco_parent_patch.rb` and `slotable_default_patch.rb` `prepend` onto
`ViewComponent::Slot` / `SlotableDefault` and read private internals
(`@__vc_component_instance`, `content_evaluated?`). The gem is pinned `~> 3.22`,
which permits any 3.x minor that could rename these without a major bump. There
are no direct specs for the patches.

- `lib/loco_motion/patches/view_component/*.rb`

**Fix:** (a) tighten the pin to `~> 3.22.0`; (b) add a boot-time guard that
raises a clear error if a patched method/ivar no longer exists, so an upgrade
fails loudly at boot instead of silently mis-rendering; (c) add direct
regression specs asserting `loco_parent` wiring and forced slot-content
evaluation.

### 3.3 Extract a `Part` value object

**Severity:** Medium

`BaseComponent` and `ComponentConfig` are bidirectionally coupled and both
spelunk a raw symbol-keyed hash (`[:default_css]`, `[:user_html]`,
`[:user_tag_name]`, …). A typo'd key fails silently as `nil`.

- `lib/loco_motion/component_config.rb`, `base_component.rb:341-411`

**Fix:** introduce a small `Part` value object (Struct/Data) with named
accessors so the part shape is defined once and both classes stop hash-spelunking.

### 3.4 Lifecycle and validation polish

**Severity:** Medium

- Add `super if defined?(super)` to `BaseComponent#before_render`
  (`base_component.rb:77-80`) so a future ViewComponent `before_render` isn't
  silently dropped.
- Decide whether the bespoke `component_initializers`/`component_setups` registry
  should remain or move to ActiveSupport callbacks; document the choice either
  way.
- `ComponentConfig#validate` only validates modifiers — also validate `sizes`
  (the infrastructure exists but is unused) and consider warning on unrecognized
  part-prefixed option keys (`component_config.rb:144-165`).
- Give error classes a shared `LocoMotion::Error < StandardError` base so
  consumers can `rescue LocoMotion::Error` (`lib/loco_motion/errors.rb`).

### 3.5 `helpers.rb` registry hygiene

**Severity:** Low/Medium

- `ActionView::Helpers.define_method("daisy_*")` injects ~70 methods into a
  framework-global namespace with no collision detection. Add a load-time guard
  that raises on duplicate generated names (`helpers.rb:94-105`).
- Entries with `names: nil` (Pagination, Mask) risk generating an empty-suffixed
  `daisy_` method; `next` on blank names.
- Consider splitting the demo/doc metadata (`example`, `title`, `group`) out of
  the library's runtime registry so the shipped gem doesn't carry demo-routing
  data.

### 3.6 Dependency hygiene

**Severity:** Medium

Eight stdlib-shim gems are pinned at tight patch levels (`base64 ~> 0.2.0`,
`bigdecimal ~> 3.1.8`, `drb`, `fiddle`, `logger`, `mutex_m`, `ostruct`,
`rdoc ~> 6.7.0`) — none are directly `require`d by the gem, and the tight `~>
x.y.z` pins force narrow version windows on downstream apps. `rdoc` is a doc
tool that belongs in dev deps.

- `loco_motion-rails.gemspec:25-32`

**Fix:** remove these as direct runtime deps (let Rails pull them) or loosen to
minor-level floors.


## Tier 4 — Component Consistency

The components are individually well-built; the issue is divergence in how the
same things are done across the set.

### 4.1 Document and standardize `before_render` / `super` ordering

**Severity:** Medium

Some components run `setup_component` **before** `super` (so `LinkableComponent`
can override the tag — button, badge, avatar, alert, stat); the form inputs run
`super` **first**. Both work but encode opposite assumptions.

**Fix:** state the rule explicitly in `BaseComponent`/a concern and add a one-line
"why" comment in each override (button/badge/avatar already have these — propagate
the pattern).

### 4.2 Extract a `FormControlComponent` concern

**Severity:** Medium

The labelable wrapper template is copy-pasted across four inputs (checkbox,
radio_button, text_input, select), including the `self.send(:end)` reserved-word
hack, and the `name/id/disabled/required` HTML-attribute block is duplicated
across six inputs.

**Fix:** have `LabelableComponent` provide a shared render helper (or partial) so
the four templates collapse to one call, and extract a `FormControlComponent`
concern that applies the common attributes + `AriableComponent` wiring.

### 4.3 Route all "may be a link" elements through `LinkableComponent`

**Severity:** Medium

Breadcrumbs, tabs, and dock hand-roll `href`/`target`/tag-switching instead of
using `LinkableComponent`, even though button/badge/avatar/link/figure/alert/stat
include it.

**Fix:** route every clickable-or-link element through `LinkableComponent` and
delete the bespoke versions.

### 4.4 Resolve `set_component_name` inconsistency

**Severity:** Medium

Only 8 of 68 components call `set_component_name`, with no discernible rule.

**Fix:** either auto-derive `component_name` from the class name in
`BaseComponent` (and drop the scattered calls), or make it required everywhere.
Right now it's noise that implies a convention nobody follows.

### 4.5 Naming, no-op overrides, and small cleanups

**Severity:** Low

- Delete redundant pass-through `initialize`/`before_render` overrides that only
  call `super` (note `super` vs `super(**kws)` actually differ — a real footgun).
- Always read options via `config_option`, never raw `kws[...]` (card, figure),
  so `.build(...)` values are honored.
- Standardize `**kws` (not `**kwargs`), `simple_<slotname>` for plain-string slot
  fallbacks, and one icon helper name (`heroicon` vs `hero_icon` are used
  interchangeably).
- Extract repeated DaisyUI class clusters into constants — the modal and alert
  close buttons should be identical but currently differ.
- Replace `chat_component.rb:63`'s regex-against-rendered-CSS branch with an
  explicit config option/modifier.

### 4.6 Accessibility pass

**Severity:** Medium

- Add default `role="status"` / `aria-label` to Loading, Progress, Status (mirror
  how Alert adds `role="alert"`), still overridable via the `aria:` shortcut.
- Make Accordion/Collapse/Menu heading levels configurable instead of hardcoded
  `<h2>`.
- (Covered in 1.6) Avatar/Figure `alt`.


## Tier 5 — Testing Strategy

The suite is genuinely behavioral (67/68 components have non-trivial specs and
the risky `build`/hook metaprogramming is well covered). The gaps are about a
missing shared contract and a few holes.

### 5.1 Shared "a LocoMotion component" passthrough example

**Severity:** High

Every component inherits css/html/aria/data/tag_name passthrough from
`BaseComponent`, but there is no shared example asserting it — and **zero**
specs test `tag_name` override, only one tests the `aria:` shorthand. A
regression in `rendered_html`/`ComponentConfig` deep-merge would slip past
nearly the whole suite.

**Fix:** add `spec/support/` with a `shared_examples "a LocoMotion component"`
covering css/html/aria/data/tag_name passthrough and `it_behaves_like` it in
every component spec.

### 5.2 Fill coverage holes

**Severity:** Medium

- Add `spec/lib/loco_motion/concerns/labelable_component_spec.rb` (the only
  concern with no dedicated spec, and the most complex).
- Add a spec for `Daisy::ThemeHelper` and a `spec/components/hero/` spec for the
  one untested component (`Hero::IconComponent`).
- Flesh out the ~6 smoke-only specs (list, list_item, label, stack, status,
  rating).
- Add a direct `ComponentConfig#smart_merge!` unit test and focused specs for the
  ViewComponent patches (see 3.2).

### 5.3 JavaScript and example-page coverage

**Severity:** Medium

- Add a JS unit runner for the four Stimulus controllers (timer math,
  theme persistence, cally keyboard handling) — none are unit-tested today.
- Add a spec that iterates `LocoMotion::Helpers::COMPONENTS` and asserts every
  `component_partial_path` resolves and renders (counts already don't line up: 67
  registered vs 66 demo views + 1 gem-only `filters`).
- Deepen Playwright from page-load smoke tests to interaction tests on JS-backed
  components (dropdown/modal open-close, swap toggle, accordion expand, theme
  persistence).


## Tier 6 — Documentation & Meta-Docs

### 6.1 README split (#73)

**Severity:** High

The README is a 1003-line / 32 KB monolith that is ~85% generic Rails tutorial
(Docker, `rails new`, HAML/DaisyUI install, Debugging, Service Objects, OmniAuth,
…). Only ~2 sections are actually about the gem. Its `## TODO` still lists
"Update to Tailwind 4 and DaisyUI 5" **unchecked** even though the top of the
same file says the project already ships them.

- `README.md` (Rails-setup chapters ~lines 89-699; stale TODO ~953-999)

**Fix:** move the Rails-setup chapters into `docs/` guides, slim the README to
About / Install / Using Components / links to demo+guides / Developing /
Contributing (~150-200 lines), and reconcile the stale TODO.

### 6.2 Fix wrong/broken meta-docs

**Severity:** High / Medium

- `AGENTS.md` is entirely unrelated boilerplate ("Browser Automation /
  chrome-devtools-mcp") with zero LocoMotion content — actively misleading to any
  tool that reads `AGENTS.md` as canonical. Replace with a pointer to CLAUDE.md
  or delete it.
- `.windsurfrules` links to `.windsurf/rules/planning.md` and `releasing.md`,
  which **don't exist** (the file is `creating_a_plan.md`; there is no releasing
  rule). Fix the link targets.

### 6.3 Consolidate convention sources

**Severity:** Medium

The YARD doc-order rule (and others) is stated independently in CLAUDE.md,
`.windsurf/rules/documenting_code.md`, and `CONTRIBUTING.md`. They agree today
but will drift.

**Fix:** make one authoritative (CLAUDE.md already calls `.windsurf/rules/`
"additional reference") and have the others link to it. Fold the stale
`NEXT_SESSION.md` scratchpad into `docs/plans/` or issues and remove it.

### 6.4 Algolia / llms pipeline doc drift

**Severity:** Medium

`docs/dev_guides/ALGOLIA.md` documents the old `LLM.txt` naming and the
`LLMTextExportService`/`LLMAggregationService` constants, but the code uses
`llms.txt`/`llms-full.txt` and `Llm*`-cased constants — the in-guide example
would raise `NameError` as written. Reconcile naming throughout (and the justfile
comment). Also document the hand-maintained `docs/demo/data/usage_patterns.md`
input.

### 6.5 Example-view duplication and YARD drift

**Severity:** Medium

Example views live in two trees (`app/views/examples/` in the gem holds only
`filters`; the other 66 live in the demo), with no rule for which tree owns an
example. Separately, demo example HAML and the `@loco_example` YARD snippets are
two independent hand-written copies that can drift.

**Fix:** pick one home for example views and document it; and either generate the
demo examples from `@loco_example` (or vice versa) or add a check that the
snippets match. Add the missing `@loco_example` to `timeline_event_component.rb`
(the only component with none).

### 6.6 Tidy `docs/plans/`

**Severity:** Low

16 completed plans sit unpruned alongside active ones with no index/archive
convention. Add an `archive/` subfolder or a status header, and let
`docs/templates/release_checklist.md` be the source of truth instead of
accumulating per-version checklists.


## Verification

For each PR spun out of this plan:

```bash
just loco-test      # library RSpec
just demo-test      # demo RSpec
just playwright     # e2e (for component/JS changes)
# plus the new `just lint` once Tier 2.1 lands
```

**Expected results:** all suites green; the new shared passthrough example
(5.1) passes for every component; no regressions in tooltips/icons/links after
the `super` fixes (1.1); the README integration snippet (1.2) actually connects
a controller when followed verbatim; and lint (2.1) passes on changed files.

Several findings above were surfaced by sub-agent review and cite exact line
numbers; **re-confirm each `file:line` before editing**, as the codebase moves
between releases.


## Notes / Scope Guards

- **No DaisyUI variants.** Per CLAUDE.md, none of this adds `size:`/`color:` or
  other visual-variant params.
- **No public API breakage intended.** The `build` rewrite (3.1) and `Part`
  object (3.3) are internal; behavior must be preserved (the existing
  `base_component_spec.rb` is the guard).
- This plan does not itself resolve the open feature issues (#41 Popover, #35
  Validator, #16 Modal-controller) — but several Tier 4/Tier 1 fixes (link
  concern, Stimulus consistency, the missing-`super` bug) are prerequisites that
  will make those features cleaner to implement.
