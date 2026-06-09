---
description: Implement the real component logic, template, spec, and demo from the plan.
argument-hint: (no arguments — reads $ARTIFACTS_DIR/plan.md and naming.json)
---

# Implement the New Component

**Workflow ID**: $WORKFLOW_ID

The `modify-component` skill is preloaded. Turn the stubs into a real component
that matches the plan.

## Phase 1: LOAD

1. Read `$ARTIFACTS_DIR/naming.json` and `$ARTIFACTS_DIR/plan.md`.
2. Read the stub files the scaffold step created (class, template, spec, demo).
3. Read the "style template" component(s) named in the plan and mirror their
   structure.

## Phase 2: IMPLEMENT

Edit the four component files to match the plan. Keep every related file in
sync. Do NOT write the YARD documentation here — the workflow's next step
(`loco-document-component`) owns that; brief inline comments are fine.

**Component class** (`*_component.rb`):
- Declare parts with `define_part :name`. NEVER define `part(:component)` and
  NEVER add `_css`/`_html` properties for parts (BaseComponent handles these).
- Declare slots with `renders_one` / `renders_many` as planned.
- Set default tag/CSS/html inside `setup_component`.
- **No `size:`/`color:`/variant params** — Daisy classes flow through `css:`.

**HAML template** (`*_component.html.haml`):
- Root is `= part(:component) do`. Render sub-elements with `= part(:name) do`.
- Keep logic minimal; no business logic in the view.

**RSpec spec** (`*_component_spec.rb`):
- Mirror the component path. Cover the behaviors listed in the plan: default
  render, each part/slot, and any option. Use `render_inline` + `have_css`.

**Demo example** (`docs/demo/.../{plural_name}.html.haml`):
- Keep the `doc_title` block. Replace the single stub `doc_example` with the
  2–4 `doc_example` blocks from the plan. Each needs a `doc.with_description`
  `:markdown` block and a working `daisy_{component_name}` invocation.
- Write real, helpful prose in the descriptions (no TODOs left behind).

## Phase 3: SELF-CHECK

Run just this component's spec to catch obvious breakage early (the workflow's
`verify` step runs the full suites next):

```bash
docker compose exec -T loco bundle exec rspec spec/components/daisy/{component_group}/{component_name}_component_spec.rb
```

Fix anything red. Confirm the total diff is still within 10 files / 500 lines.

### PHASE_3_CHECKPOINT
- [ ] Class, template, spec, and demo example fully implemented (no TODOs)
- [ ] Zero size:/color:/variant params; no `part(:component)` definition
- [ ] This component's spec passes

## Phase 4: REPORT

Write `$ARTIFACTS_DIR/implementation.md` summarizing what was built (parts,
slots, options, demo examples) and the current file/line count of the diff.
Then reply with a 3–5 line summary.
