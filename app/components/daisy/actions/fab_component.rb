# frozen_string_literal: true

module Daisy
  module Actions
    #
    # The FAB (Floating Action Button) component renders a floating button
    # that stays in the corner of the screen. When clicked or focused, it
    # can optionally show a speed dial of action buttons in a vertical or
    # flower arrangement.
    #
    # @note When no `button` or `activator` slot is provided, the component
    #   falls back to a `<div>` trigger with `role="button"` and
    #   `tabindex="0"` for cross-browser focus support. The `<div>` avoids
    #   a long-standing Safari bug where `<button>` elements may not
    #   receive CSS `:focus` on click.
    #
    # @part trigger The default trigger element rendered when no custom
    #   `button` or `activator` slot is provided. Configured as a `<div>`
    #   with `role="button"` and `tabindex="0"` for cross-browser focus
    #   support.
    #
    # @slot button [Daisy::Actions::ButtonComponent] The main FAB trigger.
    #   Pass DaisyUI button classes such as `btn-primary`, `btn-circle`,
    #   and `btn-lg` via the `css:` option.
    #
    # @slot activator [LocoMotion::BasicComponent] A fully custom activator
    #   element for the FAB trigger. Automatically adds `role="button"` and
    #   `tabindex="0"` attributes for accessibility.
    #
    # @slot action+ [Daisy::Actions::ButtonComponent] The speed dial action
    #   buttons shown when the FAB is opened.
    #
    # @slot close [LocoMotion::BasicComponent] An optional close button
    #   shown when the FAB is open. Wraps content in a `fab-close`
    #   container. Use either `close` or `main_action`, not both.
    #
    # @slot main_action [LocoMotion::BasicComponent] An optional main
    #   action button shown when the FAB is open. Wraps content in a
    #   `fab-main-action` container. Use either `main_action` or `close`,
    #   not both.
    #
    # @loco_example Basic FAB
    #   = daisy_fab do |fab|
    #     - fab.with_button(css: "btn-primary btn-circle btn-lg") do
    #       F
    #
    # @loco_example FAB with Speed Dial
    #   = daisy_fab do |fab|
    #     - fab.with_button(css: "btn-primary btn-circle btn-lg") do
    #       +
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       A
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       B
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       C
    #
    # @loco_example FAB Flower
    #   = daisy_fab(css: "fab-flower") do |fab|
    #     - fab.with_button(css: "btn-primary btn-circle btn-lg") do
    #       F
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       A
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       B
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       C
    #
    # @loco_example FAB with Main Action
    #   = daisy_fab do |fab|
    #     - fab.with_button(css: "btn-circle btn-lg") do
    #       F
    #     - fab.with_main_action do
    #       = daisy_button(css: "btn-primary") { "Save" }
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       A
    #     - fab.with_action(css: "btn-circle btn-lg") do
    #       B
    #
    class FabComponent < LocoMotion::BaseComponent
      include ViewComponent::SlotableDefault

      define_parts :trigger

      renders_one :activator, LocoMotion::BasicComponent.build(
        html: { role: "button", tabindex: 0 }
      )

      renders_one :button, Daisy::Actions::ButtonComponent

      renders_many :actions, Daisy::Actions::ButtonComponent

      renders_one :close, LocoMotion::BasicComponent.build(css: "fab-close")

      renders_one :main_action, LocoMotion::BasicComponent.build(
        css: "fab-main-action"
      )

      #
      # Adds the relevant DaisyUI classes to the component and sets up the
      # default trigger part.
      #
      def before_render
        setup_component
        setup_trigger
      end

      private

      #
      # Adds the `fab` CSS class to the component wrapper.
      #
      def setup_component
        add_css(:component, "fab")
      end

      #
      # Configures the default trigger part as a focusable `<div>` with
      # `role="button"` and `tabindex="0"` for cross-browser focus support.
      # Only used when no `button` or `activator` slot is provided.
      #
      def setup_trigger
        set_tag_name(:trigger, :div)
        add_html(:trigger, { role: "button", tabindex: 0 })
        add_css(:trigger, "btn")
      end
    end
  end
end
