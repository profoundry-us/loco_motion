#
# The FrameComponent creates a simple window-like container for showcasing
# content. Similar to the BrowserComponent but without the toolbar, it's
# perfect for:
# - Displaying application screenshots.
# - Creating simple window mockups.
# - Framing content in presentations.
# - Building marketing materials.
#
# The component provides a clean, minimal window frame that can be styled
# to match your design needs.
#
# @loco_example Basic Frame
#   = daisy_frame(css: "border border-base-300") do
#     .border-t.border-base-300.p-4
#       Window content here
#
# @loco_example Styled Frame
#   = daisy_frame(css: "bg-primary border-2") do
#     .bg-base-100.border-t.p-8.text-center
#       = image_tag("logo.png",
#         class: "max-w-xs mx-auto")
#       %p.mt-4
#         Professional window mockup
#
# @loco_example Image Frame
#   = daisy_frame(css: "shadow-xl") do
#     .p-0
#       = image_tag("screenshot.jpg",
#         class: "w-full")
#
class Daisy::Mockup::FrameComponent < LocoMotion::BaseComponent
  #
  # Creates a new Frame component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Size: `w-full`, `max-w-4xl`
  #   - Border: `border`, `border-primary`
  #   - Background: `bg-base-100`, `bg-primary`
  #   - Shadow: `shadow-lg`, `shadow-xl`
  #
  def initialize(**kws)
    super(**kws)
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "mockup-window")
  end

  #
  # Renders the frame with its content.
  #
  def call
    part(:component) do
      content
    end
  end
end
