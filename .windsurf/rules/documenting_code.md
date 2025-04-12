# Documenting Code

When documenting code, follow these procedures.

1. MUST utilize YARD documentation for Ruby files.

2. When documenting new components, MUST utilize existing components as a guide.

3. If a component uses `define_part` or `define_parts`, MUST use the `@part`
   macro to document it.

4. If a component uses `renders_one` or `renders_many`:
   a. MUST use the `@slot` macro to document it.

5. If a component uses `renders_many`:
   a. MUST use the `+` symbol after the name to indicate that it allows multiple
      calls.

6. When documenting a component:
   a. ONLY use `@param` for positional arguments and `@option` for all other
   keyword arguments.

7. All loco_examples in the YARD documentation MUST use proper HAML syntax.

8. When adding a TODO item:
   a. MUST append it to the bottom of the list in the `README.md` file

9. MUST utilize proper punctuation, including for list items.

10. If an `initialize` method does not utilize the positional arguments, NEVER
    include them in the `@param` YARD documentation.

11. All `@param` and `@option` YARD documentation MUST be on the `initialize`
    method.

12. All `@param` and `@option` YARD documentation MUST have newlines between
    them.

13. Follow this order when writing component YARD documentation:
  a. Description
  b. Notes (Optional)
  c. Parts
  d. Slots
  e. Examples

14. MUST use `@loco_example` to document our YARD examples.

15. MUST wrap lines at 80 characters.
