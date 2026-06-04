# Creating a Coding Plan

When asked to create a plan, follow these procedures.

1. MUST review the template specified by the user, or the default plan template
   if none is specified. Templates are located in the `docs/plans/templates`
   directory.
   a. For new components, use the `new_component.md` template.
   b. For modifying existing components, use the `component_modification.md`
      template.
   c. For removing components, use the `component_removal.md` template.
   d. For refactoring code, use the `refactoring.md` template.
   e. For third-party integrations, use the `integration.md` template.
   f. For database or system migrations, use the `migration.md` template.

2. MUST create a Markdown file in the `docs/plans` directory.

3. MUST utilize existing and recent plans as a guide for building new plans.
  a. MUST check filename of plans to identify recent ones

4. MUST include exact links provided by the user.

5. MUST review any links in provided GitHub issues.

6. MUST wrap lines at 80 characters.

7. NEVER add component variants unless explicitly requested.

8. After creating the plan, MUST prompt the user to review.

9. NEVER execute a plan unless explicitly requested.
