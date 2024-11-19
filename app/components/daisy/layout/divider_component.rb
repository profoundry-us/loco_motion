#
# The divider component is a simple horizontal or vertical line that separates
# content. It can be colored and have a label.
#
# @loco_example Basic Usage
#   = daisy_divider
#
# @loco_example With Text
#   = daisy_divider do
#     Hello Dividers!
#
# @loco_example Horizontal Accented With Text
#   = daisy_divider(css: "divider-horizontal divider-accent") do
#     Accent Divider
#
class Daisy::Layout::DividerComponent < LocoMotion::BaseComponent

  #
  # Add the `divider` CSS class to the component.
  #
  def before_render
    add_css(:component, "divider")
  end

  #
  # Render the component and it's content.
  #
  def call
    part(:component) { content }
  end

end
