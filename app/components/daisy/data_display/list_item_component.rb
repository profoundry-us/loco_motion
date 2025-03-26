#
# The ListItem component represents an individual row within a List component.
# It provides a consistent layout for displaying content in a list format.
#
# @part image Optional image container for the item
#
# @loco_example Basic Usage
#   = daisy_list do |list|
#     - list.with_item { "Simple list item" }
#
# @loco_example With Image
#   = daisy_list do |list|
#     - list.with_item do
#       = image_tag(src: "profile.jpg", class: "rounded-full size-8")
#       User Profile
#
# @!parse class Daisy::DataDisplay::ListItemComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::ListItemComponent < LocoMotion::BaseComponent
  #
  # Create a new ListItem component.
  #
  # @param kwargs [Hash] The keyword arguments for the component.
  #
  # @option kwargs [String] :css Additional CSS classes to apply to the list item.
  #
  def initialize(**kwargs, &block)
    super
  end

  # Called before rendering to setup the component CSS and structure
  def before_render
    set_tag_name(:component, :li)
    add_css(:component, "list-row")
  end

  def call
    part(:component) { content }
  end
end
