---
description: Add complete YARD documentation to the newly implemented component.
argument-hint: (no arguments — reads $ARTIFACTS_DIR/naming.json and plan.md)
---

# Document the New Component (YARD)

**Workflow ID**: $WORKFLOW_ID

The `document-component` skill is preloaded. The previous step implemented the
component without docs; your ONLY job is to add complete YARD documentation.

## Phase 1: LOAD

1. Read `$ARTIFACTS_DIR/naming.json` and `$ARTIFACTS_DIR/plan.md`.
2. Read the implemented component class and HAML template.
3. Read 1–2 well-documented components in the same group as references for
   tone and depth.

## Phase 2: DOCUMENT

Follow the `document-component` skill:

- Class-level order: description → `@note` → `@part` → `@slot` →
  `@loco_example`.
- Use `@loco_example` (NOT `@example`); examples in HAML with `daisy_` helpers.
- Document every `define_part` with `@part` and every slot with `@slot`.
- Put ALL `@param`/`@option` tags on `initialize`, blank line between each.
- Wrap doc lines at 80 characters.
- Documentation ONLY — do not change behavior. If you spot a real bug, note it
  in the report instead of fixing it here.

## Phase 3: SELF-CHECK

Docs are comments, but a stray character can still break the file. Re-run the
component's spec:

```bash
docker compose exec -T loco bundle exec rspec spec/components/daisy/{component_group}/{component_name}_component_spec.rb
```

### PHASE_3_CHECKPOINT
- [ ] Class docs in the required order; `@loco_example` used throughout
- [ ] Every part, slot, and param documented; lines wrapped at 80 chars
- [ ] No behavior changes; the component's spec still passes

## Phase 4: REPORT

Append a short "Documentation" section to `$ARTIFACTS_DIR/implementation.md`
(what was documented, example count). Reply with a 2–3 line summary.
