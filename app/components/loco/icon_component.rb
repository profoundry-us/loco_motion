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
# @loco_example Variants (append `/variant` to the name)
#   = loco_icon("bolt/solid")
#   = loco_icon("bolt/mini")
#
# @loco_example Customized icons
#   = loco_icon("no-symbol", css: "size-4 text-red-600")
#   = loco_icon("arrow-trending-up", css: "size-10 text-green-600")
#   = loco_icon("exclamation-triangle", css: "size-14 text-yellow-400 animate-pulse")
#
# @loco_example Another library (after syncing it into your app)
#   = loco_icon("lucide:heart")
#   = loco_icon("phosphor:heart/duotone")
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
    # @option kws icon [String] The icon to display, as a
    #   `[library:]name[/variant]` token (e.g. `"academic-cap"`,
    #   `"lucide:heart"`, `"bolt/solid"`, `"phosphor:gear/bold"`). The library
    #   and variant default to `LocoMotion.configuration.default_icon_library`
    #   (`:heroicons`) and `default_icon_variant` (`:outline`). Encode a
    #   non-default library or variant in the token — there are no separate
    #   `library:` / `variant:` options.
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
      if kws.key?(:library) || kws.key?(:variant)
        raise ArgumentError,
              "loco_icon no longer accepts `library:` or `variant:` — encode " \
              "them in the icon token instead, e.g. " \
              'loco_icon("lucide:heart/duotone").'
      end

      super

      # Accept either the :icon keyword argument or the first positional argument
      @icon = config_option(:icon, args[0])
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
        library: LocoMotion.configuration.default_icon_library,
        variant: LocoMotion.configuration.default_icon_variant,
        attributes: rendered_html(:component)
      ).to_svg.html_safe
    end
  end
end
