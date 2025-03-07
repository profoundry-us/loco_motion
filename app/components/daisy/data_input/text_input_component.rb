#
# The TextInput component renders a DaisyUI styled text input field.
# It can be used standalone or with a form builder, and supports
# various styling options including different types, sizes and variants.
#
# The component provides slots to add content before and after the input field,
# making it easy to add icons, buttons, or other elements.
#
# @part input The actual input element that users can type into.
#
# @slot start Content to display before the input field.
# @slot end+ Content to display after the input field.
#
# @loco_example Basic Usage
#   = daisy_text_input(name: "username", id: "username")
#
# @loco_example With Placeholder
#   = daisy_text_input(name: "email", id: "email", placeholder: "Enter your email")
#
# @loco_example Different Types
#   = daisy_text_input(name: "password", id: "password", type: "password")
#   = daisy_text_input(name: "email", id: "email", type: "email")
#
# @loco_example With Icons
#   = daisy_text_input(name: "search", placeholder: "Search...") do |text_input|
#     - text_input.with_start do
#       = hero_icon("magnifying-glass", size: 5, css: "text-gray-400")
#
# @loco_example With Start and End Content
#   = daisy_text_input(name: "email", placeholder: "Email address") do |text_input|
#     - text_input.with_start do
#       = hero_icon("envelope", size: 5, css: "text-gray-400")
#     - text_input.with_end do
#       = daisy_button(title: "Verify", css: "h-full rounded-l-none")
#
# @loco_example Disabled Text Input
#   = daisy_text_input(name: "username", id: "username", disabled: true)
#
class Daisy::DataInput::TextInputComponent < LocoMotion::BaseComponent
  define_part :input

  renders_one :start
  renders_one :end

  attr_reader :name, :id, :value, :placeholder, :type, :disabled, :required, :readonly

  #
  # Instantiate a new TextInput component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for the text input.
  #
  # @option kws id [String] The ID attribute for the text input.
  #
  # @option kws value [String] The initial value of the text input.
  #
  # @option kws placeholder [String] Placeholder text for the text input.
  #
  # @option kws type [String] The type of input (text, password, email, etc.).
  #   Defaults to "text".
  #
  # @option kws disabled [Boolean] Whether the text input is disabled. Defaults to
  #   false.
  #
  # @option kws required [Boolean] Whether the text input is required for form
  #   validation. Defaults to false.
  #
  # @option kws readonly [Boolean] Whether the text input is read-only. Defaults to
  #   false.
  #
  def initialize(**kws)
    super

    @name = config_option(:name)
    @id = config_option(:id)
    @value = config_option(:value, nil)
    @placeholder = config_option(:placeholder, nil)
    @type = config_option(:type, "text")
    @disabled = config_option(:disabled, false)
    @required = config_option(:required, false)
    @readonly = config_option(:readonly, false)
  end

  #
  # Calls the {setup_component} method before rendering the component.
  #
  def before_render
    setup_component
    setup_input
  end

  #
  # Sets up the component by configuring the tag name, CSS classes, and HTML
  # attributes. Sets the tag to input with appropriate type and adds the 'input'
  # CSS class.
  #
  # This configures various attributes of the text input including name, id, value,
  # placeholder, type, and states like disabled, required, and readonly.
  #
  def setup_component
    set_tag_name(:component, :label)

    add_css(:component, "input [:where(&)]:flex [:where(&)]:items-center [:where(&)]:gap-2")
  end

  #
  # Sets up the input part by configuring the tag name, CSS classes, and HTML
  # attributes. Sets the tag to input with appropriate type and adds the grow
  # styling to ensure the input expands to fill available space.
  #
  # This configures basic input attributes like name, id, value, placeholder,
  # and states like disabled, required, and readonly.
  #
  def setup_input
    set_tag_name(:input, :input)
    add_css(:input, "[:where(&)]:grow")
    add_html(:input, {
      type: @type,
      name: @name,
      id: @id,
      value: @value,
      placeholder: @placeholder,
      disabled: @disabled,
      required: @required,
      readonly: @readonly
    })
  end

  # Returns the end section content.
  #
  # Since `end` is a reserved word in Ruby, we need to use a different method
  # name in the template.
  #
  def end_content
    self.end
  end
end
