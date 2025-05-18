---
trigger: manual
---

# Documenting Code

When documenting code, follow these procedures.

1. MUST utilize YARD documentation for Ruby files.

2. When documenting new components, MUST utilize existing components as a guide.
   a. Check similar components (e.g., `CardComponent` for UI components) for patterns

3. If a component uses `define_part` or `define_parts`, MUST use the `@part`
   macro to document it.
   a. Include a brief description of what the part represents
   b. Use the format: `@part name - Description of the part's purpose`

4. If a component uses `renders_one` or `renders_many`:
   a. MUST use the `@slot` macro to document it.
   b. Include the slot's type in square brackets (e.g., `[ComponentClass]`)
   c. Describe the slot's purpose and any default behavior
   d. Use `@see` to reference related methods when applicable

5. If a component uses `renders_many`:
   a. MUST use the `+` symbol after the name to indicate that it allows multiple
      calls (e.g., `@slot items+`)

6. When documenting a component:
   a. ONLY use `@param` for positional arguments and `@option` for all other
   keyword arguments.
   b. Document all parameters in the `initialize` method, not in the class documentation

7. All loco_examples in the YARD documentation MUST use proper HAML syntax.
   a. Examples should demonstrate common use cases
   b. Include examples for different configurations and edge cases
   c. Use descriptive titles for each example

8. When adding a TODO item:
   a. MUST append it to the bottom of the list in the `README.md` file

9. MUST utilize proper punctuation, including for list items.

10. If an `initialize` method does not utilize the positional arguments, NEVER
    include them in the `@param` YARD documentation.

11. All `@param` and `@option` YARD documentation MUST be on the `initialize`
    method, not in the class documentation.

12. All `@param` and `@option` YARD documentation MUST have newlines between
    them.

13. Follow this order when writing component YARD documentation:
    a. Description - Brief explanation of the component's purpose
    b. Notes (Optional) - Any important notes or warnings about the component
    c. Parts - Documented with `@part`
    d. Slots - Documented with `@slot`
    e. Examples - Documented with `@loco_example`

14. MUST use `@loco_example` instead of `@example` to document our YARD examples.
    a. Each example should have a descriptive title
    b. Examples should be ordered from simplest to most complex
    c. Include examples for different configurations and use cases

15. MUST wrap lines at 80 characters.

16. For component documentation:
    a. Keep the class-level documentation focused on the component's purpose and structure
    b. Move parameter documentation to the `initialize` method
    c. Include a `@note` section for important behavioral notes when necessary
    d. Reference related components when appropriate

17. For slot documentation:
    a. Include the slot's type in square brackets
    b. Describe the slot's purpose and any default behavior
    c. Use `@see` to reference related methods
    d. For slots with default content, mention what the default is

18. For example formatting:
    a. Use descriptive titles that explain what the example demonstrates
    b. Order examples from simplest to most complex
    c. Include examples for different configurations and edge cases
    d. Keep examples focused and concise
