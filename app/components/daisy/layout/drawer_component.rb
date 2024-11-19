#
# The DrawerComponent shows a sidebar that can be toggled open and closed.
#
# @part input [LocoMotion::BaseComponent] The input checkbox that toggles the
#   sidebar.
# @part content_wrapper [LocoMotion::BaseComponent] The wrapper for the page
#   content.
# @part overlay [LocoMotion::BaseComponent] The overlay that covers the page
#   when the sidebar is open.
#
# @slot sidebar [Daisy::Layout::DrawerSidebarComponent] The sidebar that is
#   shown when the drawer is toggled open. Renders the overlay inside of itself.
#
# @loco_example Basic Usage
#   = daisy_drawer do |drawer|
#     - drawer.with_sidebar do
#       .bg-base-100.p-4.w-40
#         Hello sidebar!
#
#     = daisy_button(tag_name: "label", css: "btn btn-primary", title: "Open Drawer", html: { for: drawer.id })
#
class Daisy::Layout::DrawerComponent < LocoMotion::BaseComponent
  #
  # The DrawerSidebarComponent is a child of the {DrawerComponent} and renders
  # the drawer sidebar and the overlay.
  #
  class Daisy::Layout::DrawerSidebarComponent < LocoMotion::BaseComponent
    #
    # Add the `drawer-side` CSS class to the component.
    #
    def before_render
      add_css(:component, "drawer-side")
    end

    #
    # Render the sidebar, the overlay, and the content.
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
  # Create a new instance of the DrawerComponent.
  #
  # @param kws [Hash] The keyword arguments passed to the component.
  # @option kws [String] :id The ID of the drawer. Defaults to a random UUID.
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
