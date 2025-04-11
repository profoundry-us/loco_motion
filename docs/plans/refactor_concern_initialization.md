# Plan: Refactor Component Concern Initialization and Setup Hooks

## 1. Goal

*   Automate the initialization and setup logic provided by component concerns
    (e.g., `TippableComponent`, `LinkableComponent`) by adding hooks directly
    into `BaseComponent`.
*   Eliminate the need for components to explicitly call `initialize_*` and
    `setup_*` methods from included concerns.
*   Leverage the `LocoMotion::BaseComponent` to manage and execute these
    concern-specific methods at the appropriate lifecycle points (`initialize`,
    `before_render`).

## 2. Current State

*   Components like `Daisy::Actions::ButtonComponent` include concerns (e.g.,
    `LocoMotion::Concerns::TippableComponent`).
*   These components must manually call methods defined in the concerns, such as
    `initialize_tippable_component` within their `initialize` method and
    `setup_tippable_component` (often via `setup_component`) within their
    rendering lifecycle.
*   This requires boilerplate code and relies on the component author
    remembering to make these calls.

## 3. Proposed Solution

*   **Step 3.1: Implement Registration Logic in `BaseComponent`:**
    *   Modify `lib/loco_motion/base_component.rb`.
    *   Define `class_attribute` arrays directly within `BaseComponent`:
        `component_initializers` and `component_setups` (default `[]`).
    *   Define class methods `register_component_initializer(method_name)` and
        `register_component_setup(method_name)` within `BaseComponent` to append
        symbols to the respective arrays.
*   **Step 3.2: Integrate Hook Execution into `BaseComponent` Lifecycle:**
    *   Modify `LocoMotion::BaseComponent#initialize` to iterate and `send` methods
        in `self.class.component_initializers` (likely *after* the existing `super`
        call, if any, and the component's own initialization logic).
    *   Modify `LocoMotion::BaseComponent#before_render` to iterate and `send`
        methods in `self.class.component_setups` (likely *before* the existing
        `super` call, if any, or the component's main rendering logic).
    *   Ensure `super` is called appropriately if `BaseComponent` itself inherits
        and overrides these methods (check `ViewComponent::Base`).
*   **Step 3.3: Modify Existing Concerns (`TippableComponent`, `LinkableComponent`, etc.):**
    *   Use an `included do |base| ... end` block within each relevant concern.
    *   Inside the block, call `base.register_component_initializer(:_initialize_concern_name)`
        and `base.register_component_setup(:_setup_concern_name)`.
    *   Rename the actual `initialize_*` and `setup_*` methods within the concerns
        to `_initialize_*` and `_setup_*` (or similar) and consider making them
        `protected` or `private`.
*   **Step 3.4: Refactor Components (`ButtonComponent`, etc.):**
    *   Remove explicit calls to the old `initialize_*` and `setup_*` methods
        from the component's `initialize`, `setup_component`, `before_render`,
        or `call` methods.
    *   Ensure custom `initialize` or `before_render` methods in these
        components call `super` (if overriding `BaseComponent`'s methods) to
        trigger the new hook execution logic.

## 4. Affected Files

*   `lib/loco_motion/base_component.rb` (Modify)
*   `lib/loco_motion/concerns/tippable_component.rb` (Modify)
*   `lib/loco_motion/concerns/linkable_component.rb` (Modify)
*   `app/components/daisy/actions/button_component.rb` (Modify)
*   Other components including `TippableComponent` or `LinkableComponent` (Modify)
*   `test/lib/loco_motion/base_component_test.rb` (Create or Modify)
*   Potentially tests for concerns or components using them, if behavior changes.

## 5. Verification

*   **Write Tests:** Create or update tests specifically for the hook mechanism
    in `BaseComponent`. These tests should verify:
    *   Registration methods add symbols to the correct arrays.
    *   `initialize` calls registered initializer methods.
    *   `before_render` calls registered setup methods.
    *   The order of execution relative to `super` and component logic is correct.
    *   Inheritance works correctly (subclasses inherit registrations).
*   **Run All Tests:** Execute the full test suite (`make loco-test`) to catch
    any regressions in components.
*   **Manual Inspection:** Manually inspect affected components in the demo
    application to confirm functionality (e.g., tooltips, links).
