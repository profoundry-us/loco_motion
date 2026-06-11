---
description: Write and run a Playwright e2e test for the new component's demo page.
argument-hint: (no arguments — reads $ARTIFACTS_DIR/naming.json)
---

# Playwright E2E for the New Component

**Workflow ID**: $WORKFLOW_ID

The `playwright-tests` skill is preloaded. Add a focused e2e test for the demo
page and make it pass.

## Phase 1: LOAD

1. Read `$ARTIFACTS_DIR/naming.json` for `component_group` and `plural_name`.
2. Read the demo example view:
   `docs/demo/app/views/examples/daisy/{component_group}/{plural_name}.html.haml`
   — your tests mirror its `doc_example` blocks.
3. Read THREE existing e2e specs in `docs/demo/e2e/daisy/` as style templates —
   prefer specs from the same component group when available. Three reveal the
   shared conventions (structure, selectors, assertions) rather than one
   author's quirks.

## Phase 2: WRITE

Create `docs/demo/e2e/daisy/{component_group}/{plural_name}.spec.ts`, mirroring
the example file's directory structure. Write one `test(...)` per `doc_example`
block — assert the component's key DaisyUI classes/elements are visible on the
page `/examples/daisy/{component_group}/{plural_name}`. Keep each test to a
single golden path.

## Phase 3: RUN

The demo app reloads from the mounted source, but ensure it picked up the new
route first:

```bash
touch docs/demo/tmp/restart.txt
```

Then run ONLY this spec inside the demo container (TTY-safe form; the `just`
target uses `-it` which fails in non-interactive runs):

```bash
docker compose exec -T demo yarn playwright test 'e2e/daisy/{component_group}/{plural_name}.spec.ts' --reporter=dot --workers=1
```

Iterate until the spec passes. If the page genuinely cannot render (a real
component bug), fix the component — but never weaken an assertion just to make
it green.

### PHASE_3_CHECKPOINT
- [ ] Spec file created at the mirrored e2e path
- [ ] One test per demo example
- [ ] `playwright test ... --reporter=dot --workers=1` passes

## Phase 4: REPORT

Write the pass/fail result to `$ARTIFACTS_DIR/validation.md` (append; note "e2e:
PASS/FAIL" and any caveat). Reply with a one-line summary.
