<!-- omit from toc -->
# Rename Variants to Modifiers

The word `variant` already has a meaning inside of Ruby on Rails to refer to a
user-agent defined template that should be rendered.

In order to avoid potential conflicts of both code and knowledge, we propose
renaming the LocoMotion `variants` to `modifiers`.

- [Current Status](#current-status)
- [Authors / Stakeholders](#authors--stakeholders)
- [Context](#context)
  - [Constraints](#constraints)
  - [Resources](#resources)
- [Proposed Solution](#proposed-solution)
  - [Code Changes](#code-changes)
- [Updates - September 2024](#updates---september-2024)
- [ADR Tasks](#adr-tasks)

## Current Status

**Accepted** - This decision is accepted and ratified in code.

## Authors / Stakeholders

 - Topher Fangio - [topher@profoundry.us](mailto:topher@profoundry.us)

## Context

Although the idea of Rails' variants has been around for a long time, it doesn't
see much use, and I honestly forgot about it when I started building components
using ViewComponent.

However, in order to avoid confusion or code conflicts, I felt it was best to
consider renaming LocoMotion's usage.

### Constraints

Regarding the new name:

1. Should not conflict with anything else in Rails or ViewComponent.
2. Should be memorable and easy to read.
3. Should be easy to make the change.
4. Should be aligned with common naming conventions for existing libraries
   (DaisyUI in particular).

### Resources

- https://guides.rubyonrails.org/layouts_and_rendering.html#the-variants-option
- https://daisyui.com/components/button/

## Proposed Solution

Based on the DaisyUi documentation, they utilize the moniker of `modifiers` to
denote these kind of variations in the styling of the components.

We propose to use the same name.

### Code Changes

In order to update the code, it should be a simple find / replace of everywhere
that we use the word `Variant` or `variant` with the new word `Modifier` or
`modifier`.

## Updates - September 2024

Modifiers appear to be working properly and without conflict to other DaisyUI or
ViewComponent code.

## ADR Tasks

- [x] Draft the core of the ADR
- [x] Submit for review
- [x] Approved
- [x] Review / update after finishing the solution with any new context /
      learnings
