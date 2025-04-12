# Maintaining Rules

When adding or modifying Windsurf rules, follow these procedures:

1.  MUST review existing rule files in `.windsurf/rules/` to ensure the new rule
    doesn't conflict or duplicate an existing one.

2.  MUST determine the most appropriate category file for the new rule.

3.  If no suitable category file exists:
    a. MUST create a new Markdown file in the `.windsurf/rules/` directory using
       a descriptive filename (e.g., `new_category.md`).

    b. MUST update the `.windsurfrules` index file MANUALLY to include the new
       file.

4.  MUST add the new rule to the corresponding Markdown file.

5.  MUST ensure there is exactly one empty line between list items when creating
    or modifying rule files for readability.

6.  MUST wrap lines at 80 characters in all rule files within the
    `.windsurf/rules/` directory to ensure human readability and maintain a
    consistent coding style.
