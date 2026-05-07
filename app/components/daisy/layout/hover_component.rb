#
# The HoverComponent wraps any content with the DaisyUI `hover-3d` effect,
# tilting and rotating the content based on the mouse position to create an
# interactive 3D feel. Common use cases include:
# - Credit cards, ID cards, and ticket mockups.
# - Image galleries and product showcases.
# - Marketing or hero sections that benefit from a subtle 3D flourish.
#
# DaisyUI's `hover-3d` works by overlaying eight invisible "hover zones" on top
# of the content. Each zone applies a slight rotation as the cursor moves over
# it, and the combined effect produces a smooth 3D tilt. This component takes
# care of generating those eight empty zones for you so the API is just a
# wrapper around your content.
#
# Includes the {LocoMotion::Concerns::LinkableComponent} module so that
# providing an `href:` will render the wrapper as an `<a>` tag, which is the
# DaisyUI-recommended way to make the entire 3D card clickable. Avoid placing
# interactive elements (buttons, links) inside the wrapper since they will
# conflict with the hover zones.
#
# @loco_example Basic Usage
#   = daisy_hover do
#     %figure.max-w-100.rounded-2xl
#       = image_tag("creditcard.webp", alt: "3D card")
#
# @loco_example Clickable 3D Card
#   = daisy_hover(href: "/cards/123", css: "my-12 mx-2 cursor-pointer") do
#     = daisy_card(css: "w-96 bg-black text-white") do |card|
#       - card.with_title { "Card Title" }
#       Card body content goes here.
#
# @loco_example Image Gallery
#   .flex.gap-4
#     - %w[card-1.webp card-2.webp card-3.webp].each do |img|
#       = daisy_hover do
#         %figure.w-60.rounded-2xl
#           = image_tag(img, alt: "3D hover image")
#
class Daisy::Layout::HoverComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::LinkableComponent

  # The number of empty hover zones DaisyUI's `hover-3d` requires.
  HOVER_ZONE_COUNT = 8

  #
  # Creates a new Hover (3D) component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Sizing: `w-96`, `max-w-md`
  #   - Spacing: `m-4`, `mx-2 my-12`
  #   - Cursor: `cursor-pointer` (recommended when also passing `href:`)
  #
  # @option kws href [String] When provided, the wrapper renders as an `<a>`
  #   tag. Use this to make the entire 3D card clickable rather than placing
  #   interactive elements inside the wrapper.
  #
  # @option kws target [String] The link target (e.g., `_blank`). Only applied
  #   when `href:` is also provided.
  #
  def initialize(**kws)
    super(**kws)
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    setup_component
    super
  end

  private

  def setup_component
    add_css(:component, "hover-3d")
  end
end
