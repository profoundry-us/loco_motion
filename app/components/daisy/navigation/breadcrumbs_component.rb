#
# Creates a breadcrumb navigation component to show the user's location within
# a website or app.
#
# @part list_wrapper The unordered list element that wraps the breadcrumb items.
#
# @slot items+ {LocoMotion::BasicComponent} The individual breadcrumb items.
#   Each item is rendered as a list item (`<li>`) element.
#
# @example Basic breadcrumbs with text
#   = daisy_breadcrumbs do |breadcrumbs|
#     - breadcrumbs.with_item do
#       = link_to "Home", "#"
#     - breadcrumbs.with_item do
#       = link_to "Docs", "#"
#     - breadcrumbs.with_item do
#       = link_to "Components", "#"
#
# @example Breadcrumbs with icons
#   = daisy_breadcrumbs do |breadcrumbs|
#     - breadcrumbs.with_item do
#       = link_to "#" do
#         = hero_icon("home", css: "size-4 mr-1")
#         Home
#     - breadcrumbs.with_item do
#       = link_to "#" do
#         = hero_icon("document", css: "size-4 mr-1")
#         Docs
#
class Daisy::Navigation::BreadcrumbsComponent < LocoMotion::BaseComponent
  define_parts :list_wrapper

  renders_many :items, LocoMotion::BasicComponent.build(tag_name: :li)

  # Create a new instance of the BreadcrumbsComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Text: `text-sm`, `text-base-content`
  #   - Spacing: `space-x-2`, `gap-4`
  #
  def initialize(**kws)
    super(**kws)
  end

  def before_render
    add_css(:component, "breadcrumbs")
    set_tag_name(:list_wrapper, :ul)
  end
end
