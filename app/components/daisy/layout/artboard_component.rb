#
# The ArtboardComponent provides a fixed-size container that mimics mobile
# device screens. It's particularly useful for:
# - Prototyping mobile interfaces.
# - Displaying responsive design examples.
# - Creating device-specific mockups.
#
# The component includes preset sizes for common mobile devices and supports
# both portrait and landscape orientations.
#
# @loco_example Portrait Mode
#   = daisy_artboard(css: "phone-4") do
#     = daisy_hero do
#       iPhone 13 (375×812)
#
# @loco_example Landscape Mode
#   = daisy_artboard(css: "phone-4 artboard-horizontal") do
#     = daisy_hero do
#       iPhone 13 (812×375)
#
# @loco_example Custom Demo Style
#   = daisy_artboard(css: "phone-1 artboard-demo") do
#     iPhone SE (320×568)
#
class Daisy::Layout::ArtboardComponent < LocoMotion::BaseComponent

  #
  # Creates a new Artboard component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the artboard.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Device sizes: `phone-1` (320×568), `phone-2` (375×667),
  #     `phone-3` (414×736), `phone-4` (375×812), `phone-5` (414×896),
  #     `phone-6` (320×1024)
  #   - Orientation: `artboard-horizontal` for landscape mode
  #   - Demo style: `artboard-demo` for visible borders and background
  #
  def initialize(*args, **kws, &block)
    super
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "artboard")
  end

  #
  # Renders the component and its content.
  #
  def call
    part(:component) { content }
  end

end
