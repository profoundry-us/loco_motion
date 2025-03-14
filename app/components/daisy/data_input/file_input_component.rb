# frozen_string_literal: true

#
# The FileInput component renders a DaisyUI styled file input.
# It can be used standalone or with a form builder, and supports
# various styling options including different sizes and variants.
#
# @note File inputs have a border by default. Use `file-input-ghost` to remove
#   the border.
#
# @loco_example Basic Usage
#   = daisy_file_input(name: "document", id: "document")
#
# @loco_example With Accept Attribute
#   = daisy_file_input(name: "image", id: "image", accept: "image/*")
#
# @loco_example With Multiple Files
#   = daisy_file_input(name: "documents[]", id: "documents", multiple: true)
#
# @loco_example Ghost Style (No Border)
#   = daisy_file_input(name: "document", id: "document", css: "file-input-ghost")
#
# @loco_example Disabled File Input
#   = daisy_file_input(name: "document", id: "document", disabled: true)
#
class Daisy::DataInput::FileInputComponent < LocoMotion::BaseComponent
  attr_reader :name, :id, :accept, :multiple, :disabled, :required

  #
  # Instantiate a new FileInput component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for the file input.
  #
  # @option kws id [String] The ID attribute for the file input.
  #
  # @option kws accept [String] The accept attribute for the file input,
  #   specifying allowed file types.
  #
  # @option kws multiple [Boolean] Whether the file input allows multiple file
  #   selection. Defaults to false.
  #
  # @option kws disabled [Boolean] Whether the file input is disabled. Defaults to
  #   false.
  #
  # @option kws required [Boolean] Whether the file input is required for form
  #   validation. Defaults to false.
  #
  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @accept = config_option(:accept, nil)
    @multiple = config_option(:multiple, false)
    @disabled = config_option(:disabled, false)
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
  # attributes. Sets the tag to input with type 'file' and adds the 'file-input'
  # CSS class.
  #
  # This configures the name, id, accept attribute, multiple state, disabled state,
  # and required state of the file input.
  #
  def setup_component
    set_tag_name(:component, :input)

    add_css(:component, "file-input")

    add_html(:component, {
      type: "file",
      name: @name,
      id: @id,
      accept: @accept,
      multiple: @multiple,
      disabled: @disabled,
      required: @required
    })
  end

  #
  # Renders the component inline with no additional whitespace.
  #
  def call
    part(:component)
  end
end
