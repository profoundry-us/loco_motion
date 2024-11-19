<!-- omit from toc -->
# Skipping Sizes & Variants (Modifiers) for DaisyUI Components

When building custom components, LocoMotion provides a standardized way of
defining sizes and variants. Utilizing these standards with DaisyUI components
causes some difficulties in rendering the CSS properly and this ADR recommends
that we skip defining these for DaisyUI components.

> [!NOTE]
>
> The term `variant` has been renamed to `modifier` in a later ADR to better
> match the terminology DaisyUI uses as well as to avoid confusion with Rails'
> own variants feature.
>
> See [ADRs/lightweight/202404_rename_variants_to_modifiers.md][1]
> for more information.

- [Current Status](#current-status)
- [Authors](#authors)
- [Context](#context)
  - [Constraints](#constraints)
  - [Resources](#resources)
  - [Open Questions](#open-questions)
- [Proposed Solution](#proposed-solution)
  - [Pros](#pros)
  - [Cons](#cons)
  - [Considerations](#considerations)
  - [Code Changes](#code-changes)
  - [Consequences](#consequences)
- [Updates - September 2024](#updates---september-2024)
- [ADR Tasks](#adr-tasks)


## Current Status

**Accepted** - This ADR has been accepted and ratified in code.

## Authors

  - Topher Fangio [topher@profoundry.us](mailto:topher@profoundry.us)

## Context

While building out the first DaisyUI components, we ran into some trouble using
the standard Tailwind build system to properly render the CSS. Specifically,
by using the Sizes & Variants system built into LocoMotion, we were not defining
the CSS classes that Tailwind was looking for, so it wasn't generating the
necessary CSS for them.

Additionally, since DaisyUI already has a standard way of handling variants and
sizes, it felt like a lot of duplication.

The original idea behind LocoMotion's sizes and variants was that developers
could specify a single (or multiple) sizes / variant combination, and the
component would generate the necessary Tailwind classes to accommodate this.
Since DaisyUI already handles this scenario by defining a single CSS class for
the variant and sizes, LocoMotion's solution didn't offer hardly any value.

The fact that it offered little value and caused issues with rendering led to us
find a different solution.

### Constraints

We are attempting to move fairly fast with this project and slowing down to fix
build systems doesn't feel like a great use of our time. We'd like to have the
basic DaisyUI components built and working by the beginning of 2024Q3.

Since we only have one developer on the project at the moment, we also want to
stick with DaisyUI, Rails, and LocoMotion rather than attempting to find
different technologies or building new ones.

Finally, we want to make life simple for developers and do our best not to
over-complicate the solutions that we develop.

### Resources

All of the documentation for our respective libraries came in handy during this
decision:

 - [DaisyUI](https://daisyui.com/)
 - [Tailwind Content Config](https://tailwindcss.com/docs/content-configuration)
 - [Tailwind Plugins](https://tailwindcss.com/docs/plugins)

### Open Questions

n/a

## Proposed Solution

Based on all of the constraints above and our own testing, we are recommending
that we simply skip defining sizes and variants for all (or at least most) of
the DaisyUI components.

Because the components already have CSS classes defined for sizes and variants,
we can simply allow developers to utilize those pre-existing classes and the
build system will be happy.

As an example, here are the two ways we could build this:

```ruby
# LocoMotion Standard Way (not recommended)
loco_button(size: "xs", variants: [:outline, :primary])

# DaisyUI Standard Way (recommended)
loco_button(css: "btn-xs btn-outline btn-primary")
```

### Pros

 - Utilizing the DaisyUI CSS way is often shorter than the LocoMotion way

 - The Tailwind build system sees the `btn-xs`, `btn-outline`, and `btn-primary`
   classes and automatically renders the appropriate CSS

 - This is the fastest solution as we write less code

### Cons

 - We cannot warn developers if they use an undefined size / variant

 - It introduces a different way to handle DaisyUI vs custom components

 - It requires that users either refer to the DaisyUI documentation or that we
   copy much of that documenation into LocoMotion's documentation

### Considerations

Although it would be nice to warn developers if they use invalid options, it
should be relatively apparent when their component does not render properly. So
we don't feel like the first downside is that big of an issue.

Introducing a different way to handle built-in verses custom components could
lead to some confusion by developers, but we believe we can overcome any
confusion with proper documentation.

Finally, DaisyUI already has excellent documentation on all of their sizes and
variants, so pointing users to that documentation should provide a reasonable
solution without us having to copy over any documentation.

### Code Changes

In this case, our proposed solution means we won't be writing some code that we
would normally expect to write. So no major changes are necessary. We simply
need to **not** define any sizes or variants for the DaisyUI components.

### Consequences

Ultimately, this may be the preferred approach for building any pre-defined
component libraries as many of them will already have their own custom CSS for
the components.

## Updates - September 2024

After building some more components, we have realized that there are cases where
it makes sense to utlize variants (now named modifiers) in order to reduce code
clutter.

A good example of this is the Accordion component where each section needs the
`collapse-arrow` or `collapse-plus` applied to render properly. In this case, it
can be useful to set a modifier at the component level and each section can
render based on the parent component's modifiers.

That said, the same issues still apply with needing to list out the CSS classes
that are used, so the Accordion component checks the parent modifiers and adds
the appropriate classes as necessary.

**Example**

_Excerpt of the `AccordionSectionComponent` utilizing the parent
`AccordionComponent`'s modifiers to render. Code omitted for brevity._

```ruby
class AccordionComponent < LocoMotion::BaseComponent
  # ...

  define_modifiers :arrow, :plus

  # ...
end

class AccordionSectionComponent < LocoMotion::BasicComponent
  # ...

  def setup_component
    add_css(:component, "collapse")
    add_css(:component, "collapse-arrow") if loco_parent.config.modifiers.include?(:arrow)
    add_css(:component, "collapse-plus") if loco_parent.config.modifiers.include?(:plus)
  end

  # ...
end
```

## ADR Tasks

- [x] Draft the core ADR
- [x] Refine various sections
- [x] Submit for review
- [x] Make code changes
- [x] Review after implementation to see if we can add additional context /
      learnings

[1]: ../lightweight/202404_rename_variants_to_modifiers.md
