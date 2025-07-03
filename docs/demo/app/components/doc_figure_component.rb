# frozen_string_literal: true

# Documentation Figure Component
# ------------------------------
# Renders an image inside a bordered, shadowed wrapper with an optional link
# to the full-size image and an italic caption underneath.
#
# Example usage in a HAML template:
#   = render DocFigureComponent.new(
#         src: image_path("guides/better-errors.png"),
#         alt: "BetterErrors – error page screenshot")
#
# All CSS classes mirror those previously hard-coded in the guides so we can
# swap markup without changing the visual appearance.
class DocFigureComponent < ApplicationComponent
  define_parts :figure_wrapper, :caption

  # @param src [String]  Image source URL/path
  # @param alt [String]  Alt text (also used as caption)
  # @param href [String] Optional URL to wrap the figure with; defaults to +src+
  # @param css  [String] Additional CSS classes for the outer wrapper
  def initialize(src:, alt:, **kws)
    super

    @src  = src
    @alt  = alt
    @href = config_option(:href, @src)
    @target = config_option(:target, "_blank")
  end

  def before_render
    add_css(:figure_wrapper, "border border-base-300 shadow-lg hover:shadow-xl mx-auto lg:max-w-4/5")
    add_css(:caption, "mt-2 text-center text-sm italic")
  end

  def call
    part(:component) do
      safe_join([
        part(:figure_wrapper) do
          daisy_figure(src: @src, alt: @alt, href: @href, target: @target)
        end,

        part(:caption) { @alt }
      ])
    end
  end
end
