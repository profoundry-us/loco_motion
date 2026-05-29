# Coding

When writing new code, follow these procedures.

1. MUST check for uncommitted changes before starting:
   a. Run `git status --porcelain`
   b. If there are uncommitted changes, stop and prompt user to commit or stash
   c. Do not proceed with coding on a dirty working directory

2. Determine the current branch and ensure proper setup:
   a. If on `main`:
      - Run `git pull --rebase origin main` to ensure it's up-to-date
      - Create a feature branch following naming conventions (script / info
      below)
   b. If not on `main`:
      - Run `python .claude/skills/shared-scripts/check_branch.py` to validate branch name
      - Branch must match pattern: `{type}-{issue_number}-{short-description}`
      - Valid types: `feat`, `bug`, `fix`, `task`, `chore`, `docs`, `refactor`
      - If branch name is invalid, prompt user to create a proper branch
      - If branch name is valid and matches the work, continue to the plan
      - If branch name is valid but doesn't match the work, checkout main, pull, then create proper branch

3. MUST follow the plan as outlined.

4. MUST run both test suites to ensure all tests pass after making code changes:
   a. Run `just loco-test` for library unit tests
   b. Run `just demo-test` for demo application tests
   c. Both must pass before proceeding

5. MUST document all public Ruby classes and methods using YARD (see
   `documenting_code.md`).

6. When a component class has parts:
  a. NEVER include a `part(:component)` (handled by the `BaseComponent`).
  b. NEVER include properties for their `_css` and `_html` customizations
     (handled by the `BaseComponent`).

7. When creating or modifying components:
  a. Spec file must mirror the component path under `spec/components/`
  b. At least one basic "renders" test must exist
  c. New behavior must have corresponding spec coverage
  d. Example views must use `doc_title` and `doc_example` helpers
  e. Each `doc_example` must have a `doc.with_description` block

8. MUST mark off todo items in the `README.md` file.

9. NEVER delete todo items in the `README.md` file.

10. If you alter any files in `lib/loco_motion`:
  a. MUST restart the demo app using `just demo-restart`.

11. MUST review the generated code and modifications against all applicable
   Windsurf rules (especially formatting and documentation) before completing
   the coding task.

12. MUST stop and explicitly prompt the user to review the changes before
   initiating the commit process.
