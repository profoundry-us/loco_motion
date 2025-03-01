#
# The DrawerComponent provides a sliding sidebar panel that can be toggled
# open and closed. It's commonly used for:
# - Navigation menus
# - Filter panels
# - Additional information panels
# - Mobile-friendly navigation
#
# The drawer includes an overlay that covers the main content when open and
# can be configured to slide in from either the left or right side.
#
# @part input            [LocoMotion::BaseComponent] The input checkbox that
#   toggles the sidebar visibility.
#
# @part content_wrapper  [LocoMotion::BaseComponent] The wrapper for the main
#   page content that remains visible when the drawer is closed.
#
# @part overlay         [LocoMotion::BaseComponent] The semi-transparent
#   overlay that covers the main content when the drawer is open. Clicking it
#   closes the drawer.
#
# @slot sidebar        [Daisy::Layout::DrawerSidebarComponent] The sidebar
#   panel that slides in when the drawer is opened. Contains the overlay
#   within itself.
#
# @loco_example Basic Left Drawer
#   = daisy_drawer do |drawer|
#     - drawer.with_sidebar do
#       .bg-base-100.p-4.w-40
#         Menu Items
#
#     = daisy_button(tag_name: "label",
#       css: "btn btn-primary",
#       title: "Open Menu",
#       html: { for: drawer.id })
#
# @loco_example Right Drawer
#   = daisy_drawer(css: "drawer-end") do |drawer|
#     - drawer.with_sidebar do
#       .bg-base-100.p-4.w-40
#         Filter Options
#
#     = daisy_button(tag_name: "label",
#       css: "btn btn-secondary",
#       title: "Show Filters",
#       html: { for: drawer.id })
#
# @loco_example Styled Drawer
#   = daisy_drawer do |drawer|
#     - drawer.with_sidebar do
#       .bg-base-200.p-4.w-80.h-full
#         .flex.justify-between.items-center.mb-4
#           %h2.text-xl Settings
#           = daisy_button(tag_name: "label",
#             css: "btn btn-ghost btn-circle",
#             icon: "x-mark",
#             html: { for: drawer.id })
#
class Daisy::Layout::DrawerComponent < LocoMotion::BaseComponent
  #
  # The DrawerSidebarComponent is a child of the {DrawerComponent} and renders
  # the drawer sidebar and the overlay.
  #
  class Daisy::Layout::DrawerSidebarComponent < LocoMotion::BaseComponent
    #
    # Sets up the component's CSS classes.
    #
    def before_render
      add_css(:component, "drawer-side")
    end

    #
    # Renders the sidebar, the overlay, and its content.
    #
    def call
      part(:component) do
        # We need to render the parent component's overlay inside of the sidebar
        concat(loco_parent.part(:overlay))
        concat(content)
      end
    end
  end

  define_parts :input, :content_wrapper, :overlay

  renders_one :sidebar, Daisy::Layout::DrawerSidebarComponent

  #
  # The ID of the drawer. Can be passed in as a configuration option, but
  # defaults to a random UUID.
  #
  attr_reader :id

  #
  # Creates a new Drawer component.
  #
  # @param kws [Hash] Keyword arguments for customizing the drawer.
  #
  # @option kws id  [String] The ID of the drawer. Defaults to a random UUID.
  #   This is used to connect the toggle button with the drawer.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Position: `drawer-end` to slide from right instead of left
  #   - Responsive: `lg:drawer-open` to keep drawer open on large screens
  #   - Z-index: `z-[100]` to control stacking order
  #
  def initialize(**kws)
    super

    @id = config_option(:id, SecureRandom.uuid)
  end

  #
  # Sets up the various parts of the component.
  #
  def before_render
    setup_component
    setup_input
    setup_content_wrapper
    setup_overlay
  end

  #
  # Adds the `drawer` class to the component itself.
  #
  def setup_component
    add_css(:component, "drawer")
  end

  #
  # Sets up the input checkbox that toggles the sidebar.
  #
  def setup_input
    set_tag_name(:input, :input)
    add_css(:input, "drawer-toggle")
    add_html(:input, { type: "checkbox", id: @id })
  end

  #
  # Adds the `drawer-content` class to the content wrapper.
  #
  def setup_content_wrapper
    add_css(:content_wrapper, "drawer-content")
  end

  #
  # Sets up the overlay that covers the page when the sidebar is open.
  #
  def setup_overlay
    set_tag_name(:overlay, :label)
    add_css(:overlay, "drawer-overlay")
    add_html(:overlay, { for: @id, "aria-label": "close sidebar" })
  end
end
