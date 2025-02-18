#
# The JoinComponent combines multiple elements into a cohesive group without
# gaps between them. Common use cases include:
# - Button groups for toolbars.
# - Input fields with prefix/suffix elements.
# - Segmented navigation controls.
# - Pagination controls.
#
# Note: Each joined item must include the `join-item` CSS class manually, as
# automatic application could cause rendering issues in complex scenarios.
#
# @slot item+ [LocoMotion::BaseComponent] The elements to be joined together.
#   Each item should include the `join-item` CSS class.
#
# @loco_example Basic Button Group
#   = daisy_join do |join|
#     - join.with_item do
#       = daisy_button(title: "Previous",
#         css: "join-item")
#     - join.with_item do
#       = daisy_button(title: "Current",
#         css: "join-item btn-active")
#     - join.with_item do
#       = daisy_button(title: "Next",
#         css: "join-item")
#
# @loco_example Icon Button Group
#   = daisy_join do |join|
#     - join.with_item do
#       = daisy_button(icon: "chevron-left",
#         css: "join-item")
#     - join.with_item do
#       = daisy_button(icon: "home",
#         css: "join-item")
#     - join.with_item do
#       = daisy_button(icon: "chevron-right",
#         css: "join-item")
#
# @loco_example Vertical Join
#   = daisy_join(css: "join-vertical") do |join|
#     - join.with_item do
#       = daisy_button(title: "Menu",
#         css: "w-full join-item")
#     - join.with_item do
#       = daisy_button(title: "Settings",
#         css: "w-full join-item")
#     - join.with_item do
#       = daisy_button(title: "Account",
#         css: "w-full join-item")
#
class Daisy::Layout::JoinComponent < LocoMotion::BaseComponent
  renders_many :items

  #
  # Creates a new Join component.
  #
  # @param kws [Hash] Keyword arguments for customizing the join.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Direction: `join-vertical` for vertical stacking
  #   - Size: `min-w-32`, `w-full`
  #   - Spacing: `gap-0`, `gap-px` (if gaps are needed)
  #
  def initialize(**kws)
    super
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "join")
  end

  #
  # Renders all joined items in sequence.
  #
  def call
    part(:component) do
      items.each do |item|
        concat(item)
      end
    end
  end
end
