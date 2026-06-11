---
description: Research a DaisyUI component + the closest existing LocoMotion component and write an implementation plan.
argument-hint: (no arguments — reads $ARTIFACTS_DIR/naming.json)
---

# Plan a New LocoMotion Component

**Workflow ID**: $WORKFLOW_ID

You are designing a brand-new DaisyUI ViewComponent for the LocoMotion library.
Your ONLY job in this step is to produce a precise implementation plan. Do NOT
create or edit any component files yet.

## Phase 1: LOAD

1. Read `$ARTIFACTS_DIR/naming.json`. It contains the canonical
   `component_name`, `component_group`, `component_title`, `plural_name`, and
   `branch_name`. Treat these as authoritative — do not rename anything.
2. Read `CLAUDE.md` (repo root) for the component conventions, and skim
   `lib/loco_motion/helpers.rb` to see how components in this group are
   registered.

## Phase 2: RESEARCH

1. **DaisyUI markup** — Determine the canonical DaisyUI HTML structure and CSS
   class names for this component. Prefer `WebFetch` on
   `https://daisyui.com/components/{component_name}/` (try singular and a couple
   obvious variants). If the page is unavailable, fall back to your knowledge of
   DaisyUI 5. Capture the base class, any element/modifier classes, and the
   expected nesting.
2. **Closest existing component** — Glob `app/components/daisy/**/*_component.rb`
   and pick the 1–2 existing components most structurally similar to this one
   (same group when possible). Read their `.rb`, `.html.haml`, spec, and demo
   example. These are your style template — mirror their patterns exactly.

## Phase 3: DESIGN

Decide the component's Ruby API. Honor these HARD rules:

- **No `size:`, `color:`, or other visual-variant params.** Users pass DaisyUI
  classes through the `css:` kwarg. Do not invent variant options.
- Use `define_part :name` for sub-elements that need their own css/html.
- NEVER plan a `part(:component)` definition or `_css`/`_html` props for parts —
  `BaseComponent` handles those.
- Slots: `renders_one :name, "ComponentClass"` / `renders_many :names, ...`.
- Keep it small. One component, one concern. The whole PR must stay within
  **10 files and 500 changed lines**.

## Phase 4: GENERATE

Write `$ARTIFACTS_DIR/plan.md` containing:

1. **Naming table** — component_name, component_group, ModuleName (PascalCase of
   group), ClassName (PascalCase of name), plural_name, component_title, plus
   the human-readable group display string used in helpers.rb (e.g. `actions` →
   `"Actions"`, `data_display` → `"Data Display"`).
2. **File paths** — the exact 6 paths to be created/edited:
   - `app/components/daisy/{group}/{name}_component.rb`
   - `app/components/daisy/{group}/{name}_component.html.haml`
   - `spec/components/daisy/{group}/{name}_component_spec.rb`
   - `docs/demo/app/views/examples/daisy/{group}/{plural_name}.html.haml`
   - `lib/loco_motion/helpers.rb` (registration entry)
   - `CHANGELOG.md`
3. **Reference markup** — the DaisyUI HTML + class names you found.
4. **Style template** — which existing component(s) to mirror, with their paths.
5. **Proposed API** — the parts (`define_part`), slots, initializer options, the
   default tag/CSS the component sets in `setup_component`, and whether a
   Stimulus JS controller is needed (most components need none).
6. **Demo examples** — a short list (2–4) of `doc_example` blocks to showcase
   (basic usage + the most useful variations), each described in one line.
7. **Spec coverage** — the behaviors the RSpec spec must assert.

### PHASE_4_CHECKPOINT
- [ ] `$ARTIFACTS_DIR/plan.md` written with all 7 sections
- [ ] No component files were created or edited in this step
- [ ] The proposed API contains zero size:/color:/variant params

## Phase 5: REPORT

Reply with a 3–5 line summary: the component, its group, the parts/slots you
chose, and the count of demo examples planned.
