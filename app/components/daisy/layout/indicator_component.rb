#
# The IndicatorComponent positions notification elements around its content to
# draw attention to important information. Common use cases include:
# - Notification badges on avatars.
# - Cart item counters.
# - "New" badges on features.
# - Status indicators on elements.
#
# By default, indicators are positioned in the top-right corner, but they can
# be positioned anywhere around the content using CSS classes.
#
# @slot item+ [LocoMotion::BasicComponent] The items to be rendered around
#   the content. Multiple items can be added and positioned independently.
#
# @loco_example Basic Badge Indicator
#   = daisy_indicator do |indicator|
#     - indicator.with_item do
#       = daisy_badge(title: "8",
#         css: "badge-secondary")
#
#     = daisy_avatar(src: "avatar.jpg")
#
# @loco_example Multiple Indicators
#   = daisy_indicator do |indicator|
#     - indicator.with_item(css: "indicator-top indicator-start") do
#       = daisy_badge(title: "New",
#         css: "badge-accent")
#
#     - indicator.with_item(css: "indicator-bottom indicator-end") do
#       = daisy_badge(title: "Sale",
#         css: "badge-secondary")
#
#     = daisy_button(title: "View Item")
#
# @loco_example Custom Positioning
#   = daisy_indicator do |indicator|
#     - # Center of left edge
#     - indicator.with_item(css: "indicator-middle indicator-start") do
#       Online
#
#     - # Center of right edge
#     - indicator.with_item(css: "indicator-middle indicator-end") do
#       Available
#
#     .w-40.h-40.bg-base-200
#
class Daisy::Layout::IndicatorComponent < LocoMotion::BaseComponent
  renders_many :items, LocoMotion::BasicComponent.build(css: "indicator-item")

  #
  # Creates a new Indicator component.
  #
  # @param kws [Hash] Keyword arguments for customizing the indicator.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Spacing: `p-2`, `m-4`
  #   - Alignment: `inline-flex`, `inline-grid`
  #
  def initialize(**kws)
    super
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "indicator")
  end

  #
  # Renders the component, all indicator items, and the main content.
  #
  def call
    part(:component) do
      items.each do |item|
        concat(item)
      end

      concat(content) if content?
    end
  end
end
