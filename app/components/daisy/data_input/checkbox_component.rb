# frozen_string_literal: true

#
# The Checkbox component renders a DaisyUI styled checkbox input.
# It can be used standalone or with a form builder, and supports various styling
# options including toggle mode for switch-like appearance.
#
# Like Rails' own `check_box`, a named, enabled checkbox also emits a
# companion hidden field just before the input (an unchecked box submits
# nothing, so the hidden field supplies the "off" value — `"0"` by default).
# Pass `include_hidden: false` to opt out.
#
# @part hidden The companion hidden input that submits `unchecked_value` when
#   the box is unchecked. Rendered only for a named, enabled checkbox with
#   `include_hidden` on.
# @part label_wrapper The wrapper element for labels (when using
#   leading/trailing/floating labels).
# @part leading The element that contains the leading label (appears before the
#   checkbox).
# @part trailing The element that contains the trailing label (appears after the checkbox).
#
# @slot leading Custom content for the leading label.
# @slot trailing Custom content for the trailing label.
#
# @loco_example Basic Usage
#   = daisy_checkbox(name: "accept", id: "accept")
#
# @loco_example Checked Checkbox
#   = daisy_checkbox(name: "accept", id: "accept", checked: true)
#
# @loco_example Toggle Checkbox
#   = daisy_checkbox(name: "accept", id: "accept", toggle: true)
#
# @loco_example Disabled Checkbox
#   = daisy_checkbox(name: "accept", id: "accept", disabled: true)
#
# @loco_example With Leading Label
#   = daisy_checkbox(name: "accept", id: "accept", leading: "Accept:")
#
# @loco_example With Trailing Label (common for checkboxes)
#   = daisy_checkbox(name: "terms", id: "terms", trailing: "I agree to the terms and conditions")
#
# @loco_example With Custom Leading Content
#   = daisy_checkbox(name: "accept", id: "accept") do |checkbox|
#     - checkbox.with_leading do
#       %span.text-primary Accept:
#
# @loco_example With Custom Trailing Content
#   = daisy_checkbox(name: "terms", id: "terms") do |checkbox|
#     - checkbox.with_trailing do
#       %span.text-secondary I agree to the terms
#
# @loco_example Without the Companion Hidden Field
#   = daisy_checkbox(name: "accept", id: "accept", include_hidden: false)
#
module Daisy
  module DataInput
    class CheckboxComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::LabelableComponent
      include LocoMotion::Concerns::AriableComponent

      define_parts :hidden

      attr_reader :name, :id, :value, :checked, :toggle, :disabled, :required,
                  :include_hidden, :unchecked_value

      #
      # Instantiate a new Checkbox component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws name [String] The name attribute for the checkbox input.
      #
      # @option kws id [String] The ID attribute for the checkbox input.
      #
      # @option kws value [String] The value attribute for the checkbox input.
      #   Defaults to "1".
      #
      # @option kws checked [Boolean] Whether the checkbox is checked. Defaults to
      #   false.
      #
      # @option kws toggle [Boolean] Whether the checkbox should be styled as a
      #   toggle switch. Defaults to false.
      #
      # @option kws disabled [Boolean] Whether the checkbox is disabled. Defaults to
      #   false.
      #
      # @option kws required [Boolean] Whether the checkbox is required for form
      #   validation. Defaults to false.
      #
      # @option kws include_hidden [Boolean] Whether to render a companion
      #   hidden field before the checkbox so an unchecked box still submits a
      #   value (mirrors Rails' `check_box`). Only applies when a `name` is
      #   given and the checkbox is not disabled. Defaults to true.
      #
      # @option kws unchecked_value [String] The value the companion hidden
      #   field submits when the box is unchecked. Defaults to "0".
      #
      def initialize(**kws)
        super

        @name = config_option(:name)
        @id = config_option(:id)
        @value = config_option(:value, "1")
        @checked = config_option(:checked, false)
        @toggle = config_option(:toggle, false)
        @disabled = config_option(:disabled, false)
        @required = config_option(:required, false)
        @include_hidden = config_option(:include_hidden, true)
        @unchecked_value = config_option(:unchecked_value, "0")
      end

      #
      # Calls the {setup_component} method before rendering the component.
      #
      def before_render
        super

        setup_labels
        setup_hidden
        setup_component
      end

      def setup_labels
        add_css(:label_wrapper, "label") if has_any_label?
      end

      #
      # Whether to render the companion hidden field. A hidden companion only
      # makes sense for a named, enabled input — Rails likewise omits it for
      # disabled checkboxes (a disabled control submits nothing at all).
      #
      def render_hidden?
        @include_hidden && @name.present? && !@disabled
      end

      #
      # Configures the companion hidden field (see {render_hidden?}). It shares
      # the checkbox's `name` and is emitted first, so when the box is checked
      # the checkbox's value wins (the last value with the same name).
      #
      def setup_hidden
        return unless render_hidden?

        set_tag_name(:hidden, :input)
        add_html(:hidden, {
                   type: "hidden",
                   name: @name,
                   value: @unchecked_value,
                   autocomplete: "off"
                 })
      end

      #
      # Sets up the component by configuring the tag name, CSS classes, and HTML
      # attributes.
      #
      def setup_component
        set_tag_name(:component, :input)

        add_css(:component, @toggle ? "toggle" : "checkbox")

        add_html(:component, {
                   type: "checkbox",
                   name: @name,
                   id: @id,
                   value: @value,
                   checked: @checked,
                   disabled: @disabled,
                   required: @required
                 })
      end
    end
  end
end
