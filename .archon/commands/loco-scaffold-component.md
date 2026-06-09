---
description: Scaffold the 6 stub files for a new component using the new-component skill.
argument-hint: (no arguments — reads $ARTIFACTS_DIR/naming.json and plan.md)
---

# Scaffold the New Component (stubs only)

**Workflow ID**: $WORKFLOW_ID

The `new-component` skill is preloaded. Use it to create the **minimal stub
files** and register the component. Do NOT implement the real logic yet — that
is the next step.

## Phase 1: LOAD

1. Read `$ARTIFACTS_DIR/naming.json` for the canonical names.
2. Read `$ARTIFACTS_DIR/plan.md` for the file paths and the helpers.rb group
   display string.

## Phase 2: SCAFFOLD

Follow the `new-component` skill end-to-end using those exact names:

- Step 2 branch check will pass (the workflow already created the feature
  branch). If it reports you are on `main`, STOP and report an error.
- Create all stub files: the component class, the HAML template, the RSpec spec,
  and the demo example view.
- Register the component in `lib/loco_motion/helpers.rb` under the correct group.
- Because `lib/loco_motion/helpers.rb` changed, restart the demo:
  `touch docs/demo/tmp/restart.txt` (equivalent to `just demo-restart`, but
  TTY-safe for this non-interactive run).

## Phase 3: VALIDATE

Run the project's validator (replace with the real values from naming.json):

```bash
python .claude/skills/shared-scripts/validate_component.py {component_name} {component_group}
```

All checks must pass. If a file is missing, create it from the skill's template
and re-run the validator.

### PHASE_3_CHECKPOINT
- [ ] All 6 stub locations exist (4 new files + helpers.rb entry + the demo view)
- [ ] `validate_component.py` exits 0
- [ ] No real component logic added yet (stubs only)

## Phase 4: REPORT

List the files you created and confirm the validator passed.
