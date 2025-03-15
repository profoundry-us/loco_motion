# frozen_string_literal: true

#
# The Select component provides a styled dropdown select input for forms.
# It supports various styling options, including sizes, colors, and variants.
#
# @note Select inputs have a border by default and a width of 20rem. Use
#   `select-ghost` to remove the border.
#
# @part placeholder The placeholder option element that is shown when no option is selected.
#
# @slot options+ Custom options to be rendered in the select.
#
# @loco_example Using simple strings for options
#   = daisy_select(name: "size", css: "select-sm", options: ["Small", "Medium", "Large"])
#
# @loco_example Using a block to define options
#   = daisy_select(name: "color", css: "select-primary") do |select|
#     - select.with_option(value: "red", label: "Red")
#     - select.with_option(value: "green", label: "Green")
#     - select.with_option(value: "blue", label: "Blue")
class Daisy::DataInput::SelectComponent < LocoMotion::BaseComponent
  class SelectOptionComponent < LocoMotion::BasicComponent
    attr_reader :value, :label, :selected, :disabled

    #
    # Initialize a new select option component.
    #
    # @param value [String, Symbol, Integer] The value of the option.
    #
    # @param label [String] The label to display for the option.
    #
    # @param selected [Boolean] Whether the option is selected. Defaults to false.
    #
    # @param disabled [Boolean] Whether the option is disabled. Defaults to false.
    #
    # @param css [String] CSS classes to apply to the option.
    #
    # @param html [Hash] HTML attributes to apply to the option.
    #
    def initialize(value:, label:, selected: false, disabled: false, css: "", html: {}, **kws)
      @value = value
      @label = label
      @selected = selected
      @disabled = disabled
      @css = css
      @html = html
      super(**kws)
    end

    #
    # Renders the option element with the appropriate attributes.
    #
    # @return [String] The rendered HTML for the option element.
    #
    def call
      content_tag(:option, label, {
        value: value,
        selected: selected,
        disabled: disabled,
        class: @css
      }.merge(@html))
    end
  end

  renders_many :options, SelectOptionComponent

  define_part :placeholder

  attr_reader :name, :id, :value, :placeholder_text, :disabled, :required, :options_css, :options_html

  #
  # Initialize a new select component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for the select input.
  #
  # @option kws id [String] The id attribute for the select input.
  #
  # @option kws value [String, Symbol, Integer] The current value of the select input.
  #   Determines which option is selected on initial render.
  #
  # @option kws placeholder [String] Optional placeholder text to display when no
  #   option is selected. Appears as a disabled option at the top of the list.
  #
  # @option kws disabled [Boolean] Whether the select input is disabled. Defaults to
  #   false.
  #
  # @option kws required [Boolean] Whether the select input is required for form
  #   validation. Defaults to false.
  #
  # @option kws options [Array] An array of options to display in the select input.
  #   Can be an array of strings or hashes with :value and :label keys.
  #
  # @option kws options_css [String] CSS classes to apply to each option.
  #
  # @option kws options_html [Hash] HTML attributes to apply to each option.
  #
  def initialize(**kws)
    super(**kws)

    @name = config_option(:name)
    @id = config_option(:id)
    @value = config_option(:value)
    @placeholder_text = config_option(:placeholder)
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
    @options_list = config_option(:options)
    @options_css = config_option(:options_css, "")
    @options_html = config_option(:options_html, {})
  end

  #
  # Sets up the component before rendering.
  #
  def before_render
    setup_component
    setup_placeholder
  end

  #
  # Sets up the component by configuring the tag name, CSS classes, and HTML attributes.
  # Sets the tag to 'select' and adds the 'select' CSS class.
  #
  def setup_component
    set_tag_name(:component, :select)
    add_css(:component, "select")

    # Add HTML attributes for the select element
    add_html(:component,
      name: @name,
      id: @id,
      disabled: @disabled,
      required: @required
    )
  end

  #
  # Sets up the placeholder option that appears when no option is selected.
  # Adds a disabled option with an empty value.
  #
  def setup_placeholder
    set_tag_name(:placeholder, :option)
    add_html(:placeholder, value: "", disabled: true, selected: @value.blank?)
  end

  #
  # Converts the options array into SelectOptionComponent instances.
  # Handles both hash options (with value/label keys) and simple string options.
  #
  # @return [Array<SelectOptionComponent>] Array of option components or empty array if @options_list is nil.
  #
  def default_options
    return [] unless @options_list

    options_list.map do |option|
      value = option.is_a?(Hash) ? option[:value] : option
      label = option.is_a?(Hash) ? option[:label] : option.to_s

      Daisy::DataInput::SelectComponent::SelectOptionComponent.new(
        value: value,
        label: label,
        selected: value.to_s == @value.to_s,
        css: @options_css,
        html: @options_html
      )
    end
  end

  private

  #
  # Ensures the options list is always an array, even if a single option is provided.
  #
  # @return [Array] The list of options as an array.
  #
  def options_list
    @options_list.is_a?(Array) ? @options_list : [@options_list]
  end
end
