# frozen_string_literal: true

# The Select component provides a styled dropdown select input for forms.
#
# @part placeholder The placeholder option element that is shown when no option is selected.
#
# @slot options+ Custom options to be rendered in the select.
#
# @loco_example Using simple strings for options
#   = daisy_select(name: "size", css: "select-sm select-bordered", options: ["Small", "Medium", "Large"])
#
# @loco_example Using a block to define options
#   = daisy_select(name: "color", css: "select-primary") do |select|
#     - select.with_option(value: "red", label: "Red")
#     - select.with_option(value: "green", label: "Green")
#     - select.with_option(value: "blue", label: "Blue")
class Daisy::DataInput::SelectComponent < LocoMotion::BaseComponent
  class SelectOptionComponent < LocoMotion::BasicComponent
    attr_reader :value, :label, :selected, :disabled

    # Initialize a new select option component.
    #
    # @param value [String, Symbol, Integer] The value of the option.
    #
    # @param label [String] The label to display for the option.
    #
    # @param selected [Boolean] Whether the option is selected.
    #
    # @param disabled [Boolean] Whether the option is disabled.
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

  # Initialize a new select component.
  #
  # @param name [String] The name attribute for the select input.
  #
  # @param id [String] The id attribute for the select input.
  #
  # @param value [String, Symbol, Integer] The current value of the select input.
  #
  # @param placeholder [String] Optional placeholder text to display when no option is selected.
  #
  # @param disabled [Boolean] Whether the select input is disabled.
  #
  # @param required [Boolean] Whether the select input is required.
  #
  # @param options [Array] An array of options to display in the select input.
  #
  # @option options [String, Symbol, Integer] :value The value of the option.
  #
  # @option options [String] :label The label to display for the option.
  #
  # @param options_css [String] CSS classes to apply to each option.
  #
  # @param options_html [Hash] HTML attributes to apply to each option.
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

  # Sets up the component before rendering
  def before_render
    setup_component
    setup_placeholder
  end

  # Sets up the component by configuring the tag name, CSS classes, and HTML attributes
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

  def setup_placeholder
    set_tag_name(:placeholder, :option)
    add_html(:placeholder, value: "", disabled: true, selected: @value.blank?)
  end

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

  def options_list
    @options_list.is_a?(Array) ? @options_list : [@options_list]
  end
end
