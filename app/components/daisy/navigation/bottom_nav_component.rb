#
# Creates a bottom navigation bar, typically used in mobile-friendly applications
# to provide quick access to important sections.
#
# @slot sections+ {Daisy::Navigation::BottomNavSectionComponent} The sections to display in the navigation bar.
#
# @example Basic bottom nav with icons
#   = daisy_bottom_nav do |nav|
#     - nav.with_section(icon: "home", href: "#")
#     - nav.with_section(icon: "information-circle", href: "#", active: true)
#     - nav.with_section(icon: "chart-bar", href: "#")
#
# @example Bottom nav with titles
#   = daisy_bottom_nav do |nav|
#     - nav.with_section(icon: "home", href: "#", title: "Home")
#     - nav.with_section(icon: "information-circle", href: "#", title: "Info")
#     - nav.with_section(icon: "chart-bar", href: "#", title: "Stats")
#
# @example Colored bottom nav
#   = daisy_bottom_nav do |nav|
#     - nav.with_section(icon: "home", href: "#", css: "text-primary")
#     - nav.with_section(icon: "information-circle", href: "#", css: "text-secondary")
#     - nav.with_section(icon: "chart-bar", href: "#", css: "text-accent")
#
class Daisy::Navigation::BottomNavComponent < LocoMotion::BaseComponent

  #
  # A section within a Bottom Navigation component.
  #
  # @part icon The icon element for the section.
  # @part title The title element for the section.
  #
  # @example Basic section with icon
  #   = daisy_bottom_nav do |nav|
  #     - nav.with_section(icon: "home", href: "#")
  #
  # @example Active section with title
  #   = daisy_bottom_nav do |nav|
  #     - nav.with_section(icon: "information-circle", href: "#", active: true, title: "Info")
  #
  # @example Custom title content
  #   = daisy_bottom_nav do |nav|
  #     - nav.with_section(icon: "chart-bar", href: "#") do
  #       .font-bold.text-xs
  #         Stats
  #
  class Daisy::Navigation::BottomNavSectionComponent < LocoMotion::BaseComponent

    define_parts :icon, :title

    # Creates a new bottom navigation section.
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

      @icon = config_option(:icon)
      @icon_variant = config_option(:icon_variant, :outline)
      @title = config_option(:title)
      @href = config_option(:href)
      @active = config_option(:active, false)
    end

    def before_render
      if @href
        set_tag_name(:component, :a)
        add_html(:component, href: @href)
      else
        set_tag_name(:component, :button)
      end

      add_css(:component, "active") if @active

      add_css(:icon, "where:size-6")

      set_tag_name(:title, :span)
      add_css(:title, "btm-nav-label")
    end

    def call
      part(:component) do
        concat(hero_icon(@icon, variant: @icon_variant, html: rendered_html(:icon))) if @icon
        concat(part(:title) { @title }) if @title
        concat(content)
      end
    end

  end

  renders_many :sections, Daisy::Navigation::BottomNavSectionComponent

  # Creates a new bottom navigation component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Position: `relative`, `fixed bottom-0`
  #   - Width: `w-full`, `max-w-[400px]`
  #   - Border: `border`, `border-base-200`
  #
  def initialize(**kws)
    super(**kws)
  end

  def before_render
    add_css(:component, "btm-nav")
  end

  def call
    part(:component) do
      sections.each do |section|
        concat(section)
      end

      concat(content)
    end
  end

end
