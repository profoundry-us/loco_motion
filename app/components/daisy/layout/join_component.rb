# frozen_string_literal: true

module Daisy
  module Layout
    #
    # The JoinComponent combines multiple elements into a cohesive group without
    # gaps between them. Common use cases include:
    # - Button groups for toolbars.
    # - Input fields with prefix/suffix elements.
    # - Segmented navigation controls.
    # - Pagination controls.
    #
    # Items can be added using the `with_item` slot (which automatically adds the
    # `join-item` CSS class) or the `content` method (where you must add the class
    # manually).
    #
    # @note DaisyUI gives the group's corner rounding to the join's first and last
    #   *direct* children. `with_item` wraps its content in an extra `<div>`, so a
    #   bordered control (button, input) nested inside it renders with square
    #   corners. Join buttons with the `with_button` slot or direct content
    #   instead, and reserve `with_item` for plain / custom content.
    #
    # @slot item+ [LocoMotion::BaseComponent] The elements to be joined together.
    #   The `join-item` CSS class is added automatically. Because the slot wraps
    #   its content in a `<div>`, use it only for non-bordered content — buttons
    #   and inputs should use `with_button` or direct content so DaisyUI's corner
    #   rounding lands on the visible control.
    #
    # @slot button+ [Daisy::Actions::ButtonComponent] Buttons to be joined together.
    #   The `join-item` CSS class is added automatically.
    #
    # @slot radio+ [Daisy::DataInput::RadioButtonComponent] Radio buttons to be joined
    #   together. Each radio will have the `skip_styling` option set to true to prevent
    #   the automatic `radio` class from being added, and the `join-item` and `btn`
    #   classes are added automatically.
    #
    # @loco_example Basic Button Group (with with_button)
    #   = daisy_join do |join|
    #     - join.with_button(title: "Previous")
    #     - join.with_button(title: "Current", css: "btn-active")
    #     - join.with_button(title: "Next")
    #
    # @loco_example Custom Content (with with_item)
    #   = daisy_join do |join|
    #     - join.with_item do
    #       %span.p-2.bg-base-200 Previous
    #     - join.with_item do
    #       %span.p-2.bg-base-300 Current
    #     - join.with_item do
    #       %span.p-2.bg-base-200 Next
    #
    # @loco_example Direct Content (without with_item)
    #   = daisy_join do
    #     = daisy_button(title: "Previous", css: "join-item")
    #     = daisy_button(title: "Current", css: "join-item btn-active")
    #     = daisy_button(title: "Next", css: "join-item")
    #
    # @loco_example Radio Buttons (with with_radio)
    #   = daisy_join do |join|
    #     - join.with_radio(name: "options", value: "1")
    #     - join.with_radio(name: "options", value: "2")
    #     - join.with_radio(name: "options", value: "3")
    #
    # @loco_example Icon Button Group
    #   = daisy_join do |join|
    #     - join.with_button(icon: "chevron-left")
    #     - join.with_button(icon: "home")
    #     - join.with_button(icon: "chevron-right")
    #
    # @loco_example Vertical Join
    #   = daisy_join(css: "join-vertical") do |join|
    #     - join.with_button(title: "Menu", css: "w-full")
    #     - join.with_button(title: "Settings", css: "w-full")
    #     - join.with_button(title: "Account", css: "w-full")
    #
    class JoinComponent < LocoMotion::BaseComponent
      renders_many :items, LocoMotion::BasicComponent.build(css: "join-item")
      renders_many :buttons, Daisy::Actions::ButtonComponent.build(css: "join-item")
      renders_many :radios, Daisy::DataInput::RadioButtonComponent.build(skip_styling: true, css: "join-item btn")

      #
      # Creates a new Join component.
      #
      # @param kws [Hash] Keyword arguments for customizing the join.
      #
      # @option kws css [String] Additional CSS classes for styling. Common
      #   options include:
      #   - Direction: `join-vertical` for vertical stacking
      #   - Size: `min-w-32`, `w-full`
      #   - Spacing: `gap-0`, `gap-px` (if gaps are needed)
      #
      def initialize(*args, **kws, &block)
        super
      end

      #
      # Sets up the component's CSS classes.
      #
      def before_render
        add_css(:component, "join")
      end

      #
      # Renders all joined items, buttons, or radios in sequence, or renders content if none are provided.
      #
      def call
        part(:component) do
          if items?
            items.each do |item|
              concat(item)
            end
          elsif buttons?
            buttons.each do |button|
              concat(button)
            end
          elsif radios?
            radios.each do |radio|
              concat(radio)
            end
          else
            content
          end
        end
      end
    end
  end
end
