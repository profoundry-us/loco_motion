#
# The Theme Controller component provides a simple interface for switching
# between different DaisyUI themes. It renders a set of radio buttons that
# allow users to select from a predefined list of themes.
#
# The component is designed to work with DaisyUI's theme system and
# automatically updates the `data-theme` attribute on the HTML element when
# a theme is selected.
#
# @loco_example Basic Usage
#   = daisy_theme_controller
#
# @loco_example Custom Theme List
#   = daisy_theme_controller(themes: ["light", "dark", "cyberpunk"])
#
# @loco_example With Custom Styling
#   = daisy_theme_controller(css: "gap-6 p-4 bg-base-200 rounded-lg")
#
class Daisy::Actions::ThemeControllerComponent < LocoMotion::BaseComponent
  # Default list of themes to display in the controller
  SOME_THEMES = ["light", "dark", "synthwave", "retro", "cyberpunk", "wireframe"].freeze

  #
  # Creates a new instance of the ThemeControllerComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws themes [Array<String>] List of DaisyUI theme names to include
  #   in the controller. Defaults to {SOME_THEMES}.
  #
  def initialize(**kws, &block)
    super

    @themes = config_option(:themes, SOME_THEMES)
  end

  #
  # Sets up the component's CSS classes for proper layout and spacing.
  #
  def before_render
    add_css(:component, "flex flex-col lg:flex-row gap-4 items-center")
  end
end
