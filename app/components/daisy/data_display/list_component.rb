#
# The List component is a vertical layout to display information in rows. It can
# contain various content types including text, images, and actions arranged in a
# consistent format.
#
# The List component is useful for displaying structured data like user profiles,
# media libraries, or content collections with a consistent layout.
#
# @part component The main list container (ul element)
# @part header The optional header container for the list
#
# @slot item+ {Daisy::DataDisplay::ListItemComponent} Individual list items or
#   rows in the list
#
# @loco_example Basic Usage
#   = daisy_list do |list|
#     - list.with_item { "Item 1" }
#     - list.with_item { "Item 2" }
#     - list.with_item { "Item 3" }
#
# @loco_example With Header
#   = daisy_list(header: "Featured Items") do |list|
#     - list.with_item { "Featured Item 1" }
#     - list.with_item { "Featured Item 2" }
#     - list.with_item { "Featured Item 3" }
#
# @loco_example With Rich Content
#   = daisy_list(header: "Most played songs", css: "bg-base-100 rounded-box shadow-md") do |list|
#     - list.with_item do |item|
#       .flex.items-center.gap-2
#         = image_tag("album_cover.jpg", class: "size-10 rounded-box")
#         .flex.flex-col
#           .font-medium Song Title
#           .text-xs.opacity-60 Artist Name
#         = daisy_button(icon: "play", css: "btn-ghost btn-square")
#
# @loco_example With Dividers
#   = daisy_list(css: "divide-y") do |list|
#     - list.with_item { "Item with divider below" }
#     - list.with_item { "Another divided item" }
#     - list.with_item { "Last item" }
#
# @!parse class Daisy::DataDisplay::ListComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::ListComponent < LocoMotion::BaseComponent
  renders_many :items, "Daisy::DataDisplay::ListItemComponent"
  renders_one :header, LocoMotion::BasicComponent.build(tag_name: :li)

  set_component_name :list

  # @return [String] Optional header text for the list
  attr_reader :simple_header, :header_css, :header_html

  #
  # Create a new List component.
  #
  # @param kwargs [Hash] The keyword arguments for the component.
  #
  # @option kwargs [String] :header Optional header text to display at the top
  #   of the list.
  #
  # @option kwargs [String] :css Additional CSS classes to apply to the list.
  #   Common options include:
  #   - `bg-base-100` for background color
  #   - `rounded-box` for rounded corners
  #   - `shadow-md` for drop shadow
  #   - `divide-y` for dividers between items
  #
  def initialize(**kws, &block)
    super

    @simple_header = config_option(:header)
    @header_css = config_option(:header_css)
    @header_html = config_option(:header_html)
  end

  def before_render
    add_css(:component, "list")
    set_tag_name(:component, :ul)

    with_header(tag_name: :li, css: header_css, html: header_html) { simple_header } if simple_header && !header?
  end
end
