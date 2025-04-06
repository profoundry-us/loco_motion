<!-- omit from toc -->
# Integrated Label Attributes for Input Components

With DaisyUI 5, labels can now wrap inputs and provide styling. This ADR
proposes enhancing our input components with integrated label capabilities to
support this new pattern while maintaining backward compatibility.

- [Current Status](#current-status)
- [Authors / Stakeholders](#authors--stakeholders)
- [Context](#context)
  - [Constraints](#constraints)
  - [Resources](#resources)
- [Proposed Solution](#proposed-solution)
  - [Implementation Details](#implementation-details)
  - [Usage Examples](#usage-examples)
  - [Pros and Cons](#pros-and-cons)
- [Updates - March 2025](#updates---march-2025)
- [ADR Tasks](#adr-tasks)

## Current Status

**Draft** - This decision is still under consideration and has not been
integrated into the codebase yet.

## Authors / Stakeholders

 - Topher Fangio - [topher@profoundry.us](mailto:topher@profoundry.us)

## Context

In DaisyUI 4, inputs and labels were separate entities. Labels would typically
be placed before an input, or sometimes wrap around checkbox inputs, but the
inputs themselves generally provided the styling.

With DaisyUI 5, the paradigm has shifted. Labels can now wrap inputs and
provide the styling themselves. For example:

```haml
%label.input
  %input{ type: "text" }
```

We need to support both the old and new patterns to ensure backward
compatibility while enabling users to leverage the new DaisyUI 5 capabilities.

### Constraints

1. Must maintain backward compatibility with existing component usage patterns.
2. Should not significantly increase component complexity or make usage
   confusing.
3. Should align with DaisyUI 5's approach to form element styling.
4. Must maintain accessibility standards for label-input associations.
5. Should be consistent across all input component types (text, checkbox,
   select, etc.).

### Resources

- [DaisyUI 5 Label Documentation](https://daisyui.com/components/label/)
- [Current LocoMotion Label Component](https://github.com/profoundry-us/loco_motion/blob/main/app/components/daisy/data_input/label_component.rb)
- [Current LocoMotion Text Input Component](https://github.com/profoundry-us/loco_motion/blob/main/app/components/daisy/data_input/text_input_component.rb)

## Proposed Solution

Enhance existing input components with label attributes and slots, allowing
flexible positioning of labels (start, end, or floating) without creating
entirely new components.

### Implementation Details

1. **Add label attributes to input components**:
   - `start_label`: Text for a label placed at the start of the input (before in LTR, after in RTL)
   - `end_label`: Text for a label placed at the end of the input (after in LTR, before in RTL)
   - `floating_label`: Text for a label that floats inside or above the input
   - `label_for`: ID to connect label with input (defaults to input's ID)
   - `label_required`: Whether to show the input as required in the label

2. **Add corresponding label slots**:
   - `with_start`: For custom label content at the start
   - `with_end`: For custom label content at the end
   - `with_floating_label`: For custom floating label content

3. **Update the component structure**:
   - For inputs with labels, the component will render a `<label>` as the outer
     container and position the input and label text accordingly
   - Apply appropriate styling based on the label position
   - Ensure proper accessibility connections between labels and inputs

### Usage Examples

**1. Basic Input with Start Label (Traditional Style)**

```haml
= daisy_text_input(name: "username", start: "Username")
```

Rendered HTML:
```html
<label for="username" class="input">
  <span class="label">Username</span>
  <input type="text" name="username" id="username" />
</label>
```

**2. Input with End Label (Useful for Checkboxes/Radios)**

```haml
= daisy_checkbox(name: "terms", end: "I agree to the terms")
```

Rendered HTML:
```html
<label for="terms">
  <input type="checkbox" name="terms" id="terms" class="checkbox" />
  <span class="label">I agree to the terms</span>
</label>
```

**3. Input with Floating Label (New DaisyUI 5 Style)**

```haml
= daisy_text_input(name: "email", floating_label: "Email Address")
```

Rendered HTML:
```html
<label class="floating-label">
  <span>Email Address</span>
  <input type="text" name="email" id="email" class="input" />
</label>
```

**4. Using Label Slots for Custom Content**

```haml
= daisy_text_input(name: "password") do |input|
  - input.with_floating_label do
    Password
    %span.text-red-500 *
```

**5. Backward Compatible Usage (No Labels)**

```haml
= daisy_label(for: "username") do
  Username
= daisy_text_input(name: "username", id: "username")
```

### Pros and Cons

**Pros:**

- Maintains backward compatibility while supporting new DaisyUI 5 patterns
- Single source of truth for each input type
- Consistent API across all input components
- Simplifies common label-input patterns for users
- Reduces markup needed for common cases
- Ensures proper accessibility connections
- Properly supports RTL languages with directionally-neutral terminology

**Cons:**

- Increases complexity of input components
- May require significant refactoring of existing components
- Could create confusion about which styling approach to use
- Might make component documentation more complex
- Could potentially have edge cases where customization is limited

## Updates - March 2025

_This section will be updated after implementation with any lessons learned or
adjustments made._

## ADR Tasks

- [x] Draft the core of the ADR
- [ ] Submit for review
- [ ] Approved
- [ ] Implement the solution
- [ ] Review / update after finishing the solution with any new context /
      learnings
