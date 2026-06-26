# Add a TurboableComponent Concern (Turbo data-attribute sugar)


## Overview

Add a `LocoMotion::Concerns::TurboableComponent` concern that gives linkable
components first-class keyword options for the three most common Turbo data
attributes:

| Option           | Emitted attribute     |
|------------------|-----------------------|
| `turbo_frame:`   | `data-turbo-frame`    |
| `turbo_method:`  | `data-turbo-method`   |
| `turbo_confirm:` | `data-turbo-confirm`  |

This mirrors how `TippableComponent` already sugars `tip:` over `data-tip`,
removing the verbose `html: { data: { turbo_frame: "modal" } }` boilerplate at
call sites. The concern is included wherever `LinkableComponent` is already
included, since these attributes are only meaningful on link/button elements.

Fixes #202.


## External Resources

- Issue: https://github.com/profoundry-us/loco_motion/issues/202
- Turbo data attributes:
  https://turbo.hotwired.dev/reference/attributes
- Pattern reference: `lib/loco_motion/concerns/tippable_component.rb`


## Key Findings From Investigation

- **Precedence is free.** Rendered HTML is `default_html.deep_merge(user_html)`
  (`lib/loco_motion/base_component.rb:326`). `add_html` writes to
  `default_html` (`lib/loco_motion/component_config.rb:114`), while an explicit
  `html: { data: { … } }` lands in `user_html`
  (`lib/loco_motion/component_config.rb:57`). So a hand-written
  `data-turbo-frame` automatically wins over the concern's value — no special
  handling needed to honor the "explicit still takes precedence" requirement.

- **`LinkableComponent` is included by 11 components**, all of which should pick
  up the new concern:
  `Daisy::Actions::ButtonComponent`, `Daisy::DataDisplay::AvatarComponent`,
  `Daisy::DataDisplay::BadgeComponent`, `Daisy::DataDisplay::CardComponent`,
  `Daisy::DataDisplay::FigureComponent`, `Daisy::DataDisplay::StatComponent`,
  `Daisy::DataDisplay::TextRotateComponent`,
  `Daisy::Feedback::AlertComponent`, `Daisy::Layout::HoverComponent`,
  `Daisy::Navigation::DockComponent`, `Daisy::Navigation::LinkComponent`.

- **Concerns get their own isolated spec** under
  `spec/lib/loco_motion/concerns/`, using a small test component that includes
  the concern (see `tippable_component_spec.rb`). The new concern follows the
  same shape.

- **Decision: separate concern, pulled in by `LinkableComponent`.** A distinct
  `TurboableComponent` keeps the concern single-purpose and independently
  testable (matching the existing `Tippable` / `Iconable` split). Rather than
  adding `include` lines to all 11 components — which would touch 5 component
  groups and blow the 10-file PR limit — `LinkableComponent` itself does
  `base.include(TurboableComponent)` in its `included` hook. Turbo data
  attributes only make sense on link/button elements, so coupling them to the
  linkable concern is semantically correct (this is the "fold into
  `LinkableComponent`" option the issue offered, without losing a separately
  testable module). Every component that already includes `LinkableComponent`
  gets the sugar for free, and the change touches one library file instead of
  eleven.


## Implementation Steps

### 1. Add the TurboableComponent concern

**Purpose**: Provide the `turbo_frame:` / `turbo_method:` / `turbo_confirm:`
options and translate them into `data-turbo-*` attributes.

**File to Create**: `lib/loco_motion/concerns/turboable_component.rb`

**Reference Files**:
- `lib/loco_motion/concerns/tippable_component.rb`
- `lib/loco_motion/concerns/linkable_component.rb`

**Changes to Make**:

Mirror `TippableComponent`: register an initializer that reads the three
options via `config_option`, and a setup hook that builds a `data` hash and
calls `add_html(:component, { data: data })` only when at least one option is
present (no empty `data-*` attributes). Include full YARD with an `@option`
entry per option (blank line between each), per project doc conventions.

```ruby
def _initialize_turboable_component
  @turbo_frame   = config_option(:turbo_frame)
  @turbo_method  = config_option(:turbo_method)
  @turbo_confirm = config_option(:turbo_confirm)
end

def _setup_turboable_component
  data = {}
  data[:turbo_frame]   = @turbo_frame   if @turbo_frame
  data[:turbo_method]  = @turbo_method  if @turbo_method
  data[:turbo_confirm] = @turbo_confirm if @turbo_confirm
  add_html(:component, { data: data }) if data.any?
end
```

### 2. Pull the concern in via LinkableComponent

**Purpose**: Wire the sugar into every component that already renders a link,
without editing all 11 of them.

**File to Edit**: `lib/loco_motion/concerns/linkable_component.rb`

**Changes to Make**:

In the `included do |base|` hook, add `base.include(TurboableComponent)` so any
component including `LinkableComponent` also picks up `TurboableComponent`'s
initializer/setup. Update the concern's class-level YARD to mention the
inherited `turbo_*` options. The `TurboableComponent` constant autoloads on
reference (same as `Tippable` / `Iconable`), so no explicit `require` is added.

### 3. Add the concern spec

**Purpose**: Verify each attribute is emitted only when provided, and that an
explicit `html: { data: { … } }` value overrides the sugar.

**File to Create**:
`spec/lib/loco_motion/concerns/turboable_component_spec.rb`

**Changes to Make**:

Follow `tippable_component_spec.rb`: define a `TurboableTestComponent` that
includes the concern, then cover:

- No options → none of the `data-turbo-*` attributes render.
- Each option individually → only that attribute renders, with the right value.
- All three together → all three render.
- Explicit `html: { data: { turbo_frame: "x" } }` alongside `turbo_frame: "y"`
  → the explicit `"x"` wins (precedence guard).

### 4. Add a smoke test on one real component

**Purpose**: Confirm the concern actually reaches a shipping component.

**File to Edit**: `spec/components/daisy/actions/button_component_spec.rb`

**Changes to Make**:

Add a short context (mirroring the existing "with tooltip" context at
`button_component_spec.rb:160`) asserting
`daisy_button("X", href: "/y", turbo_frame: "modal")` renders
`a[data-turbo-frame='modal']`.

### 5. Document an example

**Purpose**: Make the new options discoverable in the demo.

**File to Edit**:
`docs/demo/app/views/examples/daisy/actions/buttons.html.haml` (or the closest
existing Button example view).

**Changes to Make**:

Add one `@loco_example`-style demo (HAML, `daisy_` helper) showing a button
with `turbo_frame:` / `turbo_method:` / `turbo_confirm:`. Keep it minimal — a
single representative call, not a variant matrix.

### 6. Update the CHANGELOG

**Purpose**: Record the new feature.

**File to Edit**: `CHANGELOG.md` (wrap at 110)

**Changes to Make**:

Add a `feat(...)` entry under `## [Unreleased]` → General Changes describing the
new `turbo_frame:` / `turbo_method:` / `turbo_confirm:` options and that they
apply to all linkable components. Append `Fixes #202`.

### 7. Verification Steps

**Purpose**: Confirm the concern works and nothing regressed.

**Commands to Run**:
```bash
just loco-test
```

**Expected Results**:

The new concern spec and the Button smoke test pass; the existing suite stays
green.


## Scope / PR Split

This is a single logical concern (the Turbo sugar) and should stay one PR, but
mind the repo's 500-line / 10-file limit. The concern + spec + CHANGELOG +
example is small; the 11 `include` lines are one line each. If the YARD/doc
churn pushes it over the file limit, split as: **(1)** concern + spec +
wire-in, **(2)** demo example + docs — landing the concern first.


## Open Questions

- Confirm `turbo_method:` should map to `data-turbo-method` (current Turbo),
  not legacy `data-method`. The issue specifies the former; implement that.
- Whether to also expose `turbo_action:`, `turbo_stream:`, or
  `turbo_prefetch:` later — out of scope here; the concern is trivially
  extendable when a need shows up.
