#
# Creates an icon component using Heroicons, a set of free, MIT-licensed
# high-quality SVG icons. For a complete list of available icons, visit
# https://heroicons.com.
#
# @note By default, icons are displayed with the `size-5` Tailwind class. This
#   can be overridden without using the `!` modifier because we utilize the
#   `:where()` pseudo-class to ensure our default classes have the lowest CSS
#   specificity.
#
# @loco_example Basic icon usage
#   = hero_icon("academic-cap")
#   = hero_icon(icon: "adjustments-horizontal")
#   %span.text-blue-500
#     = hero_icon("archive-box")
#
# @loco_example Customized icons
#   = hero_icon("no-symbol", css: "size-4 text-red-600")
#   = hero_icon("arrow-trending-up", css: "size-10 text-green-600")
#   = hero_icon("exclamation-triangle", css: "size-14 text-yellow-400 animate-pulse")
#
class Hero::IconComponent < LocoMotion::BaseComponent
  # Tippable concern provides tooltip functionality.
  include LocoMotion::Concerns::TippableComponent

  set_component_name :icon

  # Create a new instance of the IconComponent.
  #
  # @param args [Array] If provided, the first argument is considered the
  #   `icon` name.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws icon [String] The name of the icon to display. See
  #   https://heroicons.com for available icons.
  #
  # @option kws variant [Symbol] The variant of the icon to use
  #   (default: :outline).
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Size: `size-4`, `size-10`, `size-14`
  #   - Color: `text-red-600`, `text-green-600`, `text-yellow-400`
  #   - Animation: `animate-pulse`, `animate-spin`
  #
  # @option kws tip [String] The tooltip text to display when hovering over
  #   the icon.
  #
  def initialize(*args, **kws, &block)
    super

    # Accept either the :icon keyword argument or the first positional argument
    @icon = config_option(:icon, args[0])
    @variant = config_option(:variant)

    @css = config_option(:css, "")
  end

  def before_render
    super

    add_html(:component, { variant: @variant }) if @variant
    add_css(:component, "where:size-5") unless @css.include?("size-")
  end

  #
  # Renders the icon component.
  #
  # Because this is an inline component which might be utlized alongside text,
  # we utilize the `call` method instead of a template to ensure that no
  # additional whitespace gets added to the output.
  #
  def call
    heroicon_tag(@icon, **rendered_html(:component))
  end
end
