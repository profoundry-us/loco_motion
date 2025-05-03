# frozen_string_literal: true

#
# The Filter component is a group of radio buttons. Choosing one of the options will
# hide the others and shows a reset button next to the chosen option.
#
# @loco_example Basic Usage
#   = daisy_filter(name: "frameworks", options: ["Svelte", "Vue", "React"])
#
# @loco_example Using Filter-Reset Option
#   = daisy_filter(name: "metaframeworks") do |f|
#     - f.with_reset_button(icon: "x-mark")
#     - f.with_option(name: "metaframeworks", label: "All", css: "filter-reset")
#     - f.with_option(name: "metaframeworks", label: "Sveltekit")
#     - f.with_option(name: "metaframeworks", label: "Nuxt")
#     - f.with_option(name: "metaframeworks", label: "Next.js")
#
module Daisy
  module DataInput
    class FilterComponent < LocoMotion::BaseComponent
      class FilterOptionComponent < Daisy::DataInput::RadioButtonComponent
        #
        # Initialize a new filter option component.
        #
        # @param kws [Hash] The keyword arguments for the component.
        #
        # @option kws label [String] The aria-label for the radio button.
        #
        def initialize(**kws)
          super(**kws)

          @label = config_option(:label)
          @skip_styling = true
        end

        #
        # Setup the component before rendering.
        #
        def before_render
          # Make sure to pull the default name from the parent
          @name = config_option(:name, loco_parent&.name)

          # Call the parent setup first
          super

          # Add btn class for styling
          add_css(:component, "btn")

          # Add aria-label if specified
          if @label.present?
            add_html(:component, { "aria-label": @label })
          end
        end
      end

      class FilterResetComponent < Daisy::DataInput::RadioButtonComponent
        #
        # Initialize a new filter reset component.
        #
        # @param kws [Hash] The keyword arguments for the component.
        #
        # @option kws disabled [Boolean] Whether the reset button is disabled. Defaults to false.
        #
        def initialize(**kws)
          super(**kws)

          @skip_styling = true
        end

        #
        # Setup the component before rendering.
        #
        def before_render
          # Make sure to pull the default name from the parent
          @name = config_option(:name, loco_parent&.name)

          # Call parent setup first
          super

          # Add square styling
          add_css(:component, "where:btn where:btn-square filter-reset")

          # Set type to reset
          add_html(:component, { type: "radio" })
        end
      end

      include ViewComponent::SlotableDefault

      renders_one :reset_button, FilterResetComponent
      renders_many :options, FilterOptionComponent

      attr_reader :name

      #
      # Initialize a new filter component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws name [String] Required name attribute for the radio button group.
      #
      # @option kws options [Array] An array of options to display in the filter.
      #   Can be an array of strings, symbols, or hashes with :label keys.
      #
      def initialize(**kws)
        super(**kws)

        @name = config_option(:name)
        @options_list = config_option(:options)
      end

      #
      # Setup the component before rendering.
      #
      def before_render
        super

        setup_component
        setup_reset_button
      end

      def default_reset_button
        FilterResetComponent.new(name: @name)
      end

      #
      # Converts the options array into FilterOptionComponent instances.
      # Handles both hash options (with label keys) and simple string/symbol options.
      #
      # @return [Array<FilterOptionComponent>] Array of option components or empty array if @options_list is nil.
      #
      def standard_options
        return [] unless options_list

        options_list.map do |option|
          label = option.is_a?(Hash) ? option[:label] : option.to_s

          Daisy::DataInput::FilterComponent::FilterOptionComponent.new(
            name: @name,
            label: label,
            value: option.is_a?(Hash) ? option[:value] : option
          )
        end
      end

      #
      # Renders the filter options based on the configuration.
      # This method is used by the template to render options consistently.
      #
      # @return [String] The HTML for all options in the filter.
      #
      def render_filter_options
        result = ""

        if options?
          options.each do |option|
            option.set_loco_parent(component_ref)
            result += render(option)
          end
        elsif standard_options.present?
          standard_options.each do |option|
            option.set_loco_parent(component_ref)
            result += render(option)
          end
        end

        result.html_safe
      end

      private

      #
      # Sets up the component by configuring the tag name, CSS classes, and HTML attributes.
      #
      def setup_component
        # Add base component class
        add_css(:component, "filter")
      end

      #
      # Sets up the reset button by ensuring it has access to the parent component.
      #
      def setup_reset_button
        reset_button.set_loco_parent(component_ref)
      end

      #
      # Ensures the options list is always an array, even if a single option is provided.
      #
      # @return [Array] The list of options as an array.
      #
      def options_list
        @options_list.is_a?(Array) ? @options_list : [@options_list]
      end
    end
  end
end
