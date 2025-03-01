#
# The StackComponent creates a 3D stacking effect by layering elements on top
# of each other. Common use cases include:
# - Notification cards or alerts.
# - Photo galleries with overlap.
# - Interactive card games.
# - Animated content transitions.
#
# The component automatically positions children in a stack, with each element
# appearing on top of the previous one. This creates depth and visual interest
# in your layouts.
#
# @loco_example Basic Card Stack
#   = daisy_stack do
#     = daisy_card(css: "bg-base-100/80 shadow") do
#       Top Card
#     = daisy_card(css: "bg-base-100/80 shadow") do
#       Middle Card
#     = daisy_card(css: "bg-base-100/80 shadow") do
#       Bottom Card
#
# @loco_example Animated Stack
#   = daisy_stack do
#     = daisy_card(css: "bg-primary cursor-pointer",
#       html: { onclick: "anime({
#         targets: this,
#         translateY: '-100%',
#         opacity: 0,
#         complete: (el) => el.remove()
#       })" }) do
#       Click to Remove
#
# @loco_example Image Stack
#   = daisy_stack(css: "w-96") do
#     %img{ src: "image1.jpg" }
#     %img{ src: "image2.jpg" }
#     %img{ src: "image3.jpg" }
#
class Daisy::Layout::StackComponent < LocoMotion::BaseComponent
  #
  # Creates a new Stack component.
  #
  # @param kws [Hash] Keyword arguments for customizing the stack.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Size: `w-96`, `h-64`
  #   - Spacing: `gap-2`, `space-y-4`
  #   - Position: `relative`, `absolute`
  #
  def initialize(**kws)
    super
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "stack")
  end

  #
  # Renders the component and its stacked content.
  #
  def call
    part(:component) { content }
  end
end
