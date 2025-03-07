#
# The Label component renders a DaisyUI styled label for form inputs.
# It can be used with any form input component and provides visual styling
# consistent with other Daisy UI elements.
#
# @loco_example Basic Usage
#   = daisy_label(for: "input_id") do
#     My Label
#
# @loco_example With Label Title
#   = daisy_label(for: "input_id", title: "My Label")
#
# @loco_example Required Label
#   = daisy_label(for: "input_id", required: true) do
#     My Required Label
#
class Daisy::DataInput::LabelComponent < LocoMotion::BaseComponent
  attr_reader :for, :title, :required

  #
  # Instantiate a new Label component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws for [String] The ID of the input element this label is for.
  #   This connects the label to its associated form control for accessibility.
  #
  # @option kws title [String] The text content of the label. If not provided,
  #   the content block will be used. If a content block is provided, it will
  #   take precedence over the title option.
  #
  # @option kws required [Boolean] Whether the label is for a required input.
  #   Defaults to false.
  #
  def initialize(**kws)
    super

    @for = config_option(:for)
    @title = config_option(:title)
    @required = config_option(:required, false)
  end

  #
  # Calls the {setup_component} method before rendering the component.
  #
  def before_render
    setup_component
  end

  #
  # Sets up the component by configuring the tag name, CSS classes, and HTML
  # attributes. Sets the tag to 'label' and adds the 'label' CSS class.
  #
  # This configures the 'for' attribute to connect the label to its input and
  # adds appropriate styling for required inputs when needed.
  #
  def setup_component
    set_tag_name(:component, :label)

    add_css(:component, "label")

    add_html(:component, {
      for: @for
    })
  end

  #
  # Renders the component with its content.
  #
  def call
    part(:component) do
      if content?
        content
      elsif @title
        content_tag(:span, @title, class: "label-text")
      else
        # Fallback to empty content
        ""
      end
    end
  end
end
