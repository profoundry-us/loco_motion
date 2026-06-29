# frozen_string_literal: true

#
# Creates an icon component rendered as inline SVG from any installed icon
# library. LocoMotion bundles {https://heroicons.com Heroicons} out of the box
# (the default), and consumers can add any other supported library — Lucide,
# Phosphor, Tabler, brand sets, and more — by syncing it into their own
# application (see the `loco_motion:icons:add` task).
#
# @note By default, icons are displayed with the `size-5` Tailwind class. This
#   can be overridden without using the `!` modifier because we utilize the
#   `:where()` pseudo-class to ensure our default classes have the lowest CSS
#   specificity.
#
# @note The icon color is inherited from the parent's text color, since the
#   bundled SVGs use `currentColor`.
#
# @loco_example Basic icon usage
#   = loco_icon("academic-cap")
#   = loco_icon(icon: "adjustments-horizontal")
#   %span.text-blue-500
#     = loco_icon("archive-box")
#
# @loco_example Variants
#   = loco_icon("bolt", variant: :solid)
#   = loco_icon("bolt", variant: :mini)
#
# @loco_example Customized icons
#   = loco_icon("no-symbol", css: "size-4 text-red-600")
#   = loco_icon("arrow-trending-up", css: "size-10 text-green-600")
#   = loco_icon("exclamation-triangle", css: "size-14 text-yellow-400 animate-pulse")
#
# @loco_example Another library (after syncing it into your app)
#   = loco_icon("heart", library: :lucide)
#   = loco_icon("heart", library: :phosphor, variant: :duotone)
#
module Loco
  class IconComponent < LocoMotion::BaseComponent
    # Tippable concern provides tooltip functionality.
    include LocoMotion::Concerns::TippableComponent

    set_component_name :icon

    #
    # Create a new instance of the IconComponent.
    #
    # @param args [Array] If provided, the first argument is considered the
    #   `icon` name.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws icon [String] The name of the icon to display.
    #
    # @option kws library [String, Symbol] The icon library to render from
    #   (default: `:heroicons`). Any library synced into the app is also valid.
    #
    # @option kws variant [String, Symbol] The library variant / weight to use
    #   (default: `:outline` for Heroicons; e.g. `:solid`, `:mini`, `:micro`,
    #   or Phosphor's `:thin` / `:bold` / `:duotone`).
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
      @library = config_option(:library, LocoMotion::Icons::Renderer::DEFAULT_LIBRARY)
      @variant = config_option(:variant, LocoMotion::Icons::Renderer::DEFAULT_VARIANT)

      @css = config_option(:css, "")
    end

    def before_render
      super

      add_css(:component, "where:size-5") unless @css.include?("size-")
    end

    #
    # Renders the icon component.
    #
    # Because this is an inline component which might be utilized alongside
    # text, we utilize the `call` method instead of a template to ensure that no
    # additional whitespace gets added to the output.
    #
    def call
      LocoMotion::Icons::Renderer.new(
        name: @icon,
        library: @library,
        variant: @variant,
        attributes: rendered_html(:component)
      ).to_svg.html_safe
    end
  end
end
