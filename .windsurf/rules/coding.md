# Coding

When writing new code, follow these procedures.

0. MUST stop and show an error message if we are on the `main` Git branch.

1. MUST follow the plan as outlined.

2. MUST run `make loco-test` to ensure all tests pass after making Ruby code changes.

3. MUST document all public Ruby classes and methods using YARD (see
   `documenting_code.md`).

4. When a component class has parts:
  a. NEVER include a `part(:component)` (handled by the `BaseComponent`).
  b. NEVER include properties for their `_css` and `_html` customizations
     (handled by the `BaseComponent`).

5. MUST mark off todo items in the `README.md` file.

6. NEVER delete todo items in the `README.md` file.

7. If you alter any files in `lib/loco_motion`:
  a. MUST restart the demo app using `make demo-restart`.

8. MUST review the generated code and modifications against all applicable
   Windsurf rules (especially formatting and documentation) before completing
   the coding task.

9. MUST stop and explicitly prompt the user to review the changes before
   initiating the commit process.
