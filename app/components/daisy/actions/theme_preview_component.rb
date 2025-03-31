#
# The Theme Preview component displays a small preview of a DaisyUI theme's
# colors.  It helps users visualize the theme by showing a 2x2 grid of colored
# dots representing the base-content, primary, secondary, and accent colors of
# the theme.
#
# @part dot_base The dot showing the base-content color of the theme.
# @part dot_primary The dot showing the primary color of the theme.
# @part dot_secondary The dot showing the secondary color of the theme.
# @part dot_accent The dot showing the accent color of the theme.
#
# @loco_example Basic Usage
#   = daisy_theme_preview(theme: "light")
#
# @loco_example Custom CSS
#   = daisy_theme_preview(theme: "dark", css: "size-6")
#
class Daisy::Actions::ThemePreviewComponent < LocoMotion::BaseComponent
  define_parts :dot_base, :dot_primary, :dot_secondary, :dot_accent

  #
  # Creates a new instance of the ThemePreviewComponent.
  #
  # @param theme [String] The theme name to preview, can be provided as a
  #   positional or keyword argument.
  #
  # @option kws [String] :theme The theme name to preview (if not provided as
  #   positional argument).
  #
  # @option kws [String] :css Additional CSS classes to apply to the component.
  #
  def initialize(theme = nil, **kws, &block)
    super

    @theme = config_option(:theme, theme)
  end

  #
  # Sets up the component's CSS classes and other attributes before rendering.
  #
  def before_render
    setup_component
    setup_dots
  end

  #
  # Sets up the component's CSS classes and data attributes.
  #
  def setup_component
    classes = [
      "where:size-4 where:grid where:grid-cols-2 where:place-items-center",
      "where:shrink-0 where:rounded-md where:bg-base-100 where:shadow-sm"
    ].join(" ")

    add_css(:component, classes)
    add_html(:component, { "data-theme": @theme })
  end

  #
  # Sets up the CSS classes for the theme color dots.
  #
  def setup_dots
    add_css(:dot_base, "where:bg-base-content where:size-1 where:rounded-full")
    add_css(:dot_primary, "where:bg-primary where:size-1 where:rounded-full")
    add_css(:dot_secondary, "where:bg-secondary where:size-1 where:rounded-full")
    add_css(:dot_accent, "where:bg-accent where:size-1 where:rounded-full")
  end
end
