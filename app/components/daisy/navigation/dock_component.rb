#
# Creates a dock navigation bar, typically used in mobile-friendly applications
# to provide quick access to important sections.
#
# @slot sections+ {Daisy::Navigation::DockSectionComponent} The sections to display in the dock.
#
# @loco_example Basic dock with icons
#   = daisy_dock do |dock|
#     - dock.with_section(icon: "home", href: "#")
#     - dock.with_section(icon: "information-circle", href: "#", active: true)
#     - dock.with_section(icon: "chart-bar", href: "#")
#
# @loco_example Dock with titles
#   = daisy_dock do |dock|
#     - dock.with_section(icon: "home", href: "#", title: "Home")
#     - dock.with_section(icon: "information-circle", href: "#", title: "Info")
#     - dock.with_section(icon: "chart-bar", href: "#", title: "Stats")
#
# @loco_example Colored dock
#   = daisy_dock do |dock|
#     - dock.with_section(icon: "home", href: "#", css: "text-primary")
#     - dock.with_section(icon: "information-circle", href: "#", css: "text-secondary")
#     - dock.with_section(icon: "chart-bar", href: "#", css: "text-accent")
#
class Daisy::Navigation::DockComponent < LocoMotion::BaseComponent

  #
  # A section within a Dock component.
  #
  # @part icon The icon element for the section.
  # @part title The title element for the section.
  #
  # @loco_example Basic section with icon
  #   = daisy_dock do |dock|
  #     - dock.with_section(icon: "home", href: "#")
  #
  # @loco_example Active section with title
  #   = daisy_dock do |dock|
  #     - dock.with_section(icon: "information-circle", href: "#", active: true, title: "Info")
  #
  # @loco_example Custom title content
  #   = daisy_dock do |dock|
  #     - dock.with_section(icon: "chart-bar", href: "#") do
  #       .font-bold.text-xs
  #         Stats
  #
  class Daisy::Navigation::DockSectionComponent < LocoMotion::BaseComponent
    include LocoMotion::Concerns::IconableComponent
    include LocoMotion::Concerns::LinkableComponent

    define_part :title

    # Creates a new dock section.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws icon [String] The name of the icon to display.
    #
    # @option kws icon_variant [Symbol] The variant of the icon to use (default: :outline).
    #
    # @option kws icon_css [String] Additional CSS classes for the icon.
    #
    # @option kws title [String] Optional text to display below the icon.
    #
    # @option kws href [String] Optional URL to make the section a link.
    #
    # @option kws active [Boolean] Whether this section is currently active (default: false).
    #
    # @option kws css [String] Additional CSS classes for styling. Common
    #   options include:
    #   - Text color: `text-primary`, `text-secondary`, `text-accent`
    #   - Custom colors: `text-[#449944]`
    #
    def initialize(**kws)
      super(**kws)

      @icon_variant = config_option(:icon_variant, :outline)
      @title = config_option(:title)
      @active = config_option(:active, false)
    end

    # Configure the component before rendering.
    #
    # Adds the dock-active class if this section is active and configures the
    # title with appropriate styling.
    def before_render
      super

      set_tag_name(:component, "button") unless @href
      add_css(:component, "dock-active") if @active

      set_tag_name(:title, :span)
      add_css(:title, "dock-label")
    end

    # Render the dock section component with icon, title, and content.
    #
    # @return [String] The rendered HTML for the dock section.
    def call
      part(:component) do
        concat(render_icon)
        concat(part(:title) { @title }) if @title
        concat(content)
      end
    end

  end

  renders_many :sections, Daisy::Navigation::DockSectionComponent

  # Creates a new dock component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Position: `relative`, `fixed bottom-0`
  #   - Width: `w-full`, `max-w-[400px]`
  #   - Border: `border`, `border-base-200`
  #   - Size: `dock-xs`, `dock-sm`, `dock-md`, `dock-lg`, `dock-xl`
  #
  def initialize(**kws)
    super(**kws)
  end

  # Configure the component before rendering.
  #
  # Adds the dock CSS class to the component.
  def before_render
    add_css(:component, "dock")
  end

  # Render the dock component with all its sections and content.
  #
  # @return [String] The rendered HTML for the dock component.
  def call
    part(:component) do
      sections.each do |section|
        concat(section)
      end

      concat(content)
    end
  end

end
