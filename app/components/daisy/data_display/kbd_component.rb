#
# The Kbd (Keyboard) component displays keyboard inputs or shortcuts in a
# visually distinct way. It's perfect for showing keyboard shortcuts,
# key combinations, or individual key presses in documentation or tutorials.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @note This is an inline component that renders as a `<span>` to avoid adding
#   extra whitespace when used within text.
#
# @loco_example Basic Usage
#   %p
#     Press
#     = daisy_kbd("Ctrl")
#     = daisy_kbd("C")
#     to copy.
#
# @loco_example With Tooltip
#   %p
#     Press
#     = daisy_kbd("⌘", tip: "Command")
#     = daisy_kbd("P")
#     to print.
#
# @loco_example Key Combinations
#   %p
#     Press
#     = daisy_kbd("Alt")
#     + 
#     = daisy_kbd("Shift")
#     + 
#     = daisy_kbd("M")
#     to open the menu.
#
# @loco_example Special Keys
#   %p
#     Press
#     = daisy_kbd("↵")
#     or
#     = daisy_kbd("Enter")
#     to confirm.
#
class Daisy::DataDisplay::KbdComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  set_component_name :kbd

  #
  # Creates a new kbd component.
  #
  # @param text [String] The text to display in the keyboard component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  def initialize(*args, **kws, &block)
    super

    set_tag_name(:component, :span)
  end

  def before_render
    setup_component
  end

  #
  # Renders the kbd (Keyboard) component.
  #
  # Because this is an inline component which might be utlized alongside text,
  # we utilize the `call` method instead of a template to ensure that no
  # additional whitespace gets added to the output.
  #
  def call
    part(:component) { content }
  end

  private

  def setup_component
    add_css(:component, "kbd")
  end
end
