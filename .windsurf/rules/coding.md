# Coding

When writing new code, follow these proceedures.

0. MUST stop and show an error message if we are on the `main` Git branch.

1. MUST follow the plan as outlined.

2. MUST test all Ruby code.

3. MUST document all public Ruby classes and methods.

4. MUST follow the principles of KISS (Keep It Stupid Simple).

5. MUST follow the principles of DRY (Don't Repeat Yourself).

6. MUST regularly run ALL tests during coding sessions.

7. When a component class has parts:
  a. NEVER include a `part(:component)` (handled by the BaseComponent).
  b. NEVER include properties for their `_css` and `_html` customizations (handled by the BaseComponent).

8. MUST mark off todo items in the README.

9. NEVER delete todo items in the README.

10. If you alter any files in `lib/loco_motion`:
  a. MUST restart the demo app.
