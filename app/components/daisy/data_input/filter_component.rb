# frozen_string_literal: true

#
# The Filter component is a group of radio buttons where choosing one option
# hides the others and shows a reset button.
#
# @loco_example Basic Usage
#   = daisy_filter(name: "frameworks", options: ["Svelte", "Vue", "React"])
#
# @loco_example Using Hash Options
#   = daisy_filter(name: "languages", options: [
#     { label: "Ruby", value: "ruby" },
#     { label: "JavaScript", value: "js" },
#     { label: "Python", value: "py" }
#   ])
#
# @loco_example Custom Styling
#   = daisy_filter(name: "priorities", css: "items-center") do |f|
#     - f.with_reset_button(css: "btn-accent btn-sm rounded-full")
#     - f.with_option(label: "Low", css: "btn-outline btn-success")
#     - f.with_option(label: "Medium", css: "btn-outline btn-warning")
#     - f.with_option(label: "High", css: "btn-outline btn-error")
#
# @loco_example Within Form Builder
#   = form_with(model: @post) do |form|
#     = form.daisy_filter(:category, options: ["News", "Tech", "Sports"])
#     = form.submit "Save", class: "btn btn-primary mt-4"
#
# @loco_example Form Builder With Block
#   = form_with(model: @user) do |form|
#     = form.daisy_filter(:role) do |f|
#       - f.with_option(label: "Admin", value: "admin")
#       - f.with_option(label: "Editor", value: "editor")
#       - f.with_option(label: "Viewer", value: "viewer")
#     = form.submit "Update", class: "btn btn-primary mt-4"
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
          @index = config_option(:index)
          @skip_styling = true
        end

        #
        # Setup the component before rendering.
        #
        def before_render
          # Make sure to pull the default name from the parent
          @name = config_option(:name, loco_parent&.name)
          @id = config_option(:id, "#{loco_parent&.id}_#{@index}")

          # Call the parent setup first
          super

          # Add btn class for styling
          add_css(:component, "btn")
          add_html(:component, { id: @id })

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
          @id = config_option(:id, "#{loco_parent&.id}_reset")

          # Call parent setup first
          super

          # Add square styling
          add_css(:component, "where:btn where:btn-square filter-reset")

          # Set type to reset
          add_html(:component, { type: "radio", id: @id })
        end
      end

      include ViewComponent::SlotableDefault

      renders_one :reset_button, FilterResetComponent
      renders_many :options, FilterOptionComponent

      attr_reader :name, :id

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
      # @option kws value [String] The current value of the filter (for form integration).
      #
      def initialize(**kws)
        super(**kws)

        @name = config_option(:name)
        @id = config_option(:id, SecureRandom.uuid)
        @options_list = config_option(:options)
        @value = config_option(:value)
      end

      #
      # Setup the component before rendering.
      #
      def before_render
        super

        setup_component
        setup_reset_button if reset_button?
      end

      def default_reset_button
        comp = FilterResetComponent.new(name: @name)

        comp.set_loco_parent(component_ref)

        comp
      end

      #
      # Converts the options array into FilterOptionComponent instances.
      # Handles both hash options (with label keys) and simple string/symbol options.
      #
      # @return [Array<FilterOptionComponent>] Array of option components or empty array if @options_list is nil.
      #
      def standard_options
        return [] unless options_list

        options_list.map.with_index do |option, index|
          label = option.is_a?(Hash) ? option[:label] : option.to_s
          value = option.is_a?(Hash) ? option[:value] : option

          # Check if this option should be selected based on the component's value
          checked = @value.present? && @value.to_s == value.to_s

          Daisy::DataInput::FilterComponent::FilterOptionComponent.new(
            name: @name,
            label: label,
            value: value,
            checked: checked,
            index: index
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
        [@options_list].flatten.compact
      end
    end
  end
end
