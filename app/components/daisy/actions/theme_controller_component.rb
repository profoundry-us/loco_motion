#
# The ThemeComponent serves as a foundation for building a full Theme Switcher.
# It provides the building blocks that you will use such at the Theme Preview,
# Theme Radio, and Stimulus ThemeController.
#
# @loco_example Basic Usage
#   = daisy_theme_controller do |tc|
#     - tc.themes.each do |theme|
#       = tc.build_theme_preview(theme)
#       = tc.build_radio_input(theme)
#
class Daisy::Actions::ThemeControllerComponent < LocoMotion::BaseComponent
  # Default list of themes to display in the controller
  SOME_THEMES = ["light", "dark", "synthwave", "retro", "cyberpunk", "wireframe"].freeze

  attr_reader :themes

  #
  # Creates a new instance of the ThemeControllerComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws [Array<String>] :themes List of DaisyUI theme names to include
  #   in the controller. Defaults to {SOME_THEMES}.
  #
  def initialize(**kws, &block)
    super

    @themes = config_option(:themes, SOME_THEMES)
  end

  #
  # Sets up the component with theme Stimulus controller.
  #
  def before_render
    add_stimulus_controller(:component, :theme)
  end

  #
  # Renders the component and its content.
  #
  def call
    part(:component) { content }
  end

  #
  # Creates a radio input for use in selecting themes.
  #
  # @param theme [String] The name of the theme that the input controls.
  # @param options [Hash] Additional options to pass to the component.
  #
  # @return [Daisy::DataInput::RadioButtonComponent] A new radio button component instance.
  #
  def build_radio_input(theme, **options)
    options[:css] = (options[:css] || "").concat(" theme-controller")
    default_options = { name: "theme", id: "theme-#{theme}", value: theme }

    render Daisy::DataInput::RadioButtonComponent.new(**default_options.deep_merge(options))
  end

  #
  # Helper method to create a theme preview showing the theme's colors in a 2x2 grid.
  #
  # @param theme [String] The theme name to preview.
  #
  # @option options [Integer] :size Size of the preview in Tailwind size units.
  #   Defaults to 4 (1rem).
  #
  # @option options [Boolean] :shadow Whether to add a shadow. Defaults to true.
  #
  # @option options [String] :css Additional CSS classes.
  #
  # @return [Daisy::Actions::ThemePreviewComponent] A new theme preview component instance.
  #
  def build_theme_preview(theme, **options)
    render Daisy::Actions::ThemePreviewComponent.new(
      theme: theme,
      **options
    )
  end
end
