# Maintaining Rules

When adding or modifying Windsurf rules, follow these procedures:

1.  MUST review existing rule files in `.windsurf/rules/` to ensure the new rule doesn't conflict or duplicate an existing one.

2.  MUST determine the most appropriate category file for the new rule.

3.  MUST add the new rule to the corresponding Markdown file.

4.  MUST ensure newlines exist between all rule items for readability.

5.  If no suitable category file exists:
    a. MUST create a new Markdown file in the `.windsurf/rules/` directory using a descriptive filename (e.g., `new_category.md`).

    b. MUST output the Markdown snippet needed for the user to manually update the main `.windsurfrules` index file.
