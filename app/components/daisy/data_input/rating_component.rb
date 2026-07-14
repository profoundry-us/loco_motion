# frozen_string_literal: true

module Daisy
  module DataInput
    #
    # The Rating component renders a DaisyUI styled rating input using radio buttons.
    # It can be used standalone or with a form builder, allowing users to select a
    # rating from 1 to a configurable maximum value. Supports customization of size,
    # colors, and initial value.
    #
    # @part hidden_input The hidden radio input that lets the rating start
    #   unselected; checked whenever `value` is blank.
    #
    # @slot items+ [RatingItemComponent] Custom rating items to render
    #   instead of the auto-generated star inputs (e.g. to build half-star
    #   ratings with `with_item`).
    #
    # @loco_example Basic Usage
    #   = daisy_rating(name: "product_rating", id: "product_rating")
    #
    # @loco_example Disabled Rating
    #   = daisy_rating(name: "disabled_rating", value: 3, disabled: true)
    #
    # @loco_example Rating with Different Colors
    #   = daisy_rating(name: "primary_rating", css: "[&>input]:bg-primary")
    #   = daisy_rating(name: "warning_rating", css: "[&>input]:bg-warning")
    #
    # @loco_example Rating with Different Sizes
    #   = daisy_rating(name: "small_rating", css: "rating-sm")
    #   = daisy_rating(name: "large_rating", css: "rating-lg")
    #
    class RatingComponent < LocoMotion::BaseComponent
      #
      # Inner component for rendering individual rating items as radio inputs.
      #
      class RatingItemComponent < LocoMotion::BasicComponent
        #
        # Sets up the component before rendering.
        #
        def before_render
          set_tag_name(:component, :input)
          add_html(:component, { name: loco_parent.name, type: "radio" })
        end

        #
        # Renders the component with the appropriate attributes.
        # Takes the name from the parent component and sets the type to radio.
        #
        # @return [String] The rendered HTML for the rating item.
        #
        def call
          part(:component)
        end
      end

      define_part :hidden_input

      renders_many :items, RatingItemComponent

      attr_reader :name, :value, :max, :disabled, :required, :id, :inputs_css, :inputs_html

      #
      # Instantiate a new Rating component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws name [String] The name attribute for the radio inputs.
      #
      # @option kws value [Integer] The current rating value.
      #
      # @option kws max [Integer] The maximum rating value (default: 5).
      #
      # @option kws disabled [Boolean] Whether the rating is disabled. Defaults to
      #   false. When disabled, users cannot interact with the rating control.
      #
      # @option kws required [Boolean] Whether the rating input is required for form
      #   validation. Defaults to false. Applied only to the first star's
      #   input (`rating == 1`); native radio-group validation still covers
      #   the whole group.
      #
      # @option kws id [String] The ID applied to the `.rating` container
      #   `<div>`, not to any individual radio input.
      #
      # @option kws inputs_css [String] CSS classes to apply to each rating
      #   input. Only styles the auto-generated star items; custom `items`
      #   slot content is unaffected.
      #
      # @option kws inputs_html [Hash] HTML attributes to apply to each
      #   rating input. Only applies to the auto-generated star items;
      #   custom `items` slot content is unaffected.
      #
      def initialize(**kws)
        super

        @name = config_option(:name)
        @value = config_option(:value)
        @max = config_option(:max, 5)
        @disabled = config_option(:disabled, false)
        @required = config_option(:required, false)
        @id = config_option(:id)
        @inputs_css = config_option(:inputs_css)
        @inputs_html = config_option(:inputs_html, {})
      end

      #
      # Calls the {setup_component} and {setup_hidden_input} methods before rendering
      # the component. This prepares the rating container and creates a hidden input
      # if needed.
      #
      def before_render
        setup_component
        setup_hidden_input

        super
      end

      #
      # Sets up the component by configuring the tag name and CSS classes.
      #
      def setup_component
        set_tag_name(:component, :div)
        add_css(:component, "rating")
        add_html(:component, id: @id) if @id
      end

      #
      # Sets up a hidden input so that the rating can start empty.
      #
      def setup_hidden_input
        set_tag_name(:hidden_input, :input)
        add_css(:hidden_input, "hidden")
        add_html(:hidden_input, { type: "radio", name: @name, value: nil, checked: @value.blank? })
      end

      #
      # Declares some default items to use if no custom items are provided.
      #
      def star_items
        (1..@max).map do |rating|
          input_attrs = {
            loco_parent: component_ref,
            css: ["where:mask where:mask-star", @inputs_css].compact.join(" "),
            aria: { label: "#{rating} star" },
            html: {
              name: @name,
              value: rating,
              checked: @value == rating,
              required: @required && rating == 1,
              disabled: @disabled,
              **@inputs_html
            }
          }

          RatingItemComponent.new(**input_attrs)
        end
      end
    end
  end
end
