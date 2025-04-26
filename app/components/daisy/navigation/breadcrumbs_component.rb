#
# Creates a breadcrumb navigation component to show the user's location within
# a website or app.
#
# @part list_wrapper The unordered list element that wraps the breadcrumb items.
#
# @slot items+ {LocoMotion::BasicComponent} The individual breadcrumb items.
#   Each item is rendered as a list item (`<li>`) element.
#
# @loco_example Basic breadcrumbs with text
#   = daisy_breadcrumbs do |breadcrumbs|
#     - breadcrumbs.with_item(title: "Docs", href: "/")
#     - breadcrumbs.with_item("Breadcrumbs", "/examples")
#     - breadcrumbs.with_item(css: "italic") do
#       This example
#
# @loco_example Breadcrumbs with icons
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


  # Component for a single breadcrumb item in a breadcrumbs trail.
  #
  # @part link The link element wrapping the breadcrumb content when an href is
  #   provided.
  #
  # @loco_example Simple usage
  #   = render Daisy::Navigation::BreadcrumbItemComponent.new("Home", "/")
  #
  # @loco_example With icon
  #   = render Daisy::Navigation::BreadcrumbItemComponent.new("Home", "/", icon: :home)
  #
  # @see Daisy::Navigation::BreadcrumbsComponent
  class Daisy::Navigation::BreadcrumbItemComponent < LocoMotion::BaseComponent
    include LocoMotion::Concerns::IconableComponent
    include LocoMotion::Concerns::TippableComponent

    define_part :link

    # Initialize a breadcrumb item component.
    #
    # @param title [String, nil] The display text for the breadcrumb.
    #
    # @param href [String, nil] The URL for the breadcrumb link.
    #
    # @param args [Array] Additional positional arguments passed to the
    #   component.
    #
    # @param kws [Hash] Additional keyword options.
    #
    # @option kws icon [Symbol] Icon name to display before the title.
    #
    # @option kws tip [String] Tooltip text shown on hover.
    def initialize(title = nil, href = nil, *args, **kws)
      super

      @simple_title = config_option(:title, title)
      @href = config_option(:href, href)
    end

    # Configure the component before rendering.
    #
    # Sets the component tag to be a list item and configures the link part with
    # the href value.
    def before_render
      set_tag_name(:component, :li)

      set_tag_name(:link, "a")
      add_html(:link, { href: @href })
    end

    def call
      part(:component) do
        if @href
          part(:link) do
            render_icon_and_content
          end
        else
          render_icon_and_content
        end
      end
    end

    # Render the icon (if provided) and content.
    #
    # @return [String] The rendered HTML for the icon and content.
    def render_icon_and_content
      concat(render_icon)
      concat(content || @simple_title)
    end
  end

  define_parts :list_wrapper

  renders_many :items, Daisy::Navigation::BreadcrumbItemComponent

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

  # Configure the component before rendering.
  #
  # Adds the breadcrumbs CSS class and sets the list wrapper to use an
  # unordered list element.
  def before_render
    add_css(:component, "breadcrumbs")
    set_tag_name(:list_wrapper, :ul)
  end
end
