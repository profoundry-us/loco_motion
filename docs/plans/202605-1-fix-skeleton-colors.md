
# Fix Skeleton Colors (Issue #98)

## Overview

Skeleton elements show incorrect or inconsistent colors on the demo site
when applied to existing components (badge, button, alert, chat). The root
causes are:

1. Inconsistent text-hiding strategies across components (`text-transparent`
   on buttons/chat vs `text-base-content/50` on badge).
2. DaisyUI 5 introduced a `skeleton-text` utility class that animates text
   color using the same shimmer gradient as `skeleton`, which should replace
   the ad-hoc `text-transparent` / `text-base-content/50` approaches.

The demo app's DaisyUI is already at v5.5.19 (which includes `skeleton-text`),
so no package upgrade is required.

Fixes #98 — https://github.com/profoundry-us/loco_motion/issues/98

## External Resources

- DaisyUI Skeleton docs: https://daisyui.com/components/skeleton/
- `skeleton-text` CSS:
  `docs/demo/node_modules/daisyui/components/skeleton.css`

## Implementation Steps

### 1. Update Example View

**Purpose**: Replace ad-hoc text-hiding classes with `skeleton-text` for
visual consistency, matching DaisyUI 5's intended usage pattern.

**File to Edit**:
`docs/demo/app/views/examples/daisy/feedback/skeletons.html.haml`

**Changes to Make**:

- On the `daisy_badge` line: replace `text-base-content/50` with
  `skeleton-text`.
- On both `daisy_button` lines: replace `text-transparent` with
  `skeleton-text`.
- On the `daisy_chat` bubble lines: replace `text-transparent` with
  `skeleton-text`.
- Visually review in the running demo to confirm the shimmer gradient looks
  correct on each component. Adjust any remaining background-color conflicts
  (e.g. add `bg-transparent` or another override) if a component's own
  background obscures the skeleton shimmer.

### 2. Update Component YARD Docs

**Purpose**: Keep the inline code examples in the component class consistent
with the updated demo and document `skeleton-text` as the recommended
approach.

**File to Edit**:
`app/components/daisy/feedback/skeleton_component.rb`

**Changes to Make**:

- In the `@loco_example Component Loading States` block, replace
  `text-transparent` and `text-slate-400` / `text-base-content/50` with
  `skeleton-text` across all usages.
- In the `@option kws css` description, remove the mention of
  `text-transparent` and add `skeleton-text` as the recommended class for
  hiding placeholder text.

### 3. Update RSpec Tests

**Purpose**: Add a test context that documents the `skeleton-text` usage
pattern so it doesn't regress.

**File to Edit**:
`spec/components/daisy/feedback/skeleton_component_spec.rb`

**Changes to Make**:

- Rename or update the existing `"with hidden text"` context (currently
  uses `text-transparent`) to use `skeleton-text` instead, since that is
  now the preferred class.
- Update any assertions that reference `text-transparent` to reference
  `skeleton-text`.

### 4. Verification

**Purpose**: Confirm colors look correct in the live demo and all tests pass.

**Commands to Run**:

```bash
just loco-test
```

```bash
docker compose exec -it demo yarn playwright test \
  'e2e/feedback/skeletons' --reporter dot --workers 1
```

**Expected Results**:

- All skeleton shapes render with the expected `bg-base-300` shimmer.
- Badge, button, alert, and chat skeletons show a uniform color — no
  component-specific background bleeding through.
- Placeholder text in buttons/chat/badge animates with the shimmer gradient
  via `skeleton-text`, matching the DaisyUI 5 design intent.
- RSpec suite passes with no failures.
