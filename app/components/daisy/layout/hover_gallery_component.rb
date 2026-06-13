# frozen_string_literal: true

#
# The HoverGalleryComponent displays a container of images where the first
# image is visible by default and hovering horizontally reveals the others.
# Common use cases include product cards on e-commerce sites, portfolios, and
# image galleries. DaisyUI supports up to 10 images.
#
# The underlying HTML is a `<figure>` containing `<img>` elements. DaisyUI
# creates invisible columns over the figure; hovering each column reveals the
# corresponding image.
#
# @note By default the gallery is rendered with a 3:2 aspect ratio
#   (`where:aspect-[3/2]`) so that images with differing aspect ratios don't
#   shift the container's height as they are revealed on hover. The default
#   uses DaisyUI's zero-specificity `where:` variant and is skipped entirely
#   when you pass your own `aspect-*` utility (e.g. `aspect-square`) via
#   `css:`, so it is easy to override.
#
# @slot image+ One or more images to display in the gallery. Each image
#   accepts `src:` and `alt:` keyword arguments along with any standard HTML
#   attribute via `html:`.
#
# @loco_example Basic Hover Gallery
#   = daisy_hover_gallery(css: "max-w-60") do |gallery|
#     - gallery.with_image(src: image_path("landscapes/beach.jpg"), alt: "Beach")
#     - gallery.with_image(src: image_path("landscapes/desert.jpg"), alt: "Desert")
#     - gallery.with_image(src: image_path("landscapes/forest.jpg"), alt: "Forest")
#
# @loco_example Hover Gallery with Shorthand
#   - srcs = %w[beach desert forest].map { |s| image_path("landscapes/#{s}.jpg") }
#   = daisy_hover_gallery(srcs: srcs, css: "max-w-60")
#
# @loco_example Hover Gallery in a Card
#   = daisy_card(css: "card-sm bg-base-200 max-w-60 shadow") do |card|
#     - card.with_top_figure do
#       = daisy_hover_gallery do |gallery|
#         - gallery.with_image(src: image_path("landscapes/beach.jpg"))
#         - gallery.with_image(src: image_path("landscapes/desert.jpg"))
#         - gallery.with_image(src: image_path("landscapes/forest.jpg"))
#     - card.with_title { "Gallery Card" }
#     %p A card with a hover gallery as the figure.
#
module Daisy
  module Layout
    class HoverGalleryComponent < LocoMotion::BaseComponent
      # Renders a single image inside the hover gallery.
      class ImageComponent < LocoMotion::BasicComponent
        def initialize(src: nil, alt: nil, **kws)
          super(**kws)
          @src = src
          @alt = alt
        end

        def before_render
          set_tag_name(:component, :img)
          add_html(:component, { src: @src, alt: @alt }.compact)
          super
        end
      end

      renders_many :images, ImageComponent

      #
      # Creates a new HoverGalleryComponent.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws srcs [Array<String>] An optional array of image source URLs
      #   for simple usage without blocks. Each URL is rendered as an `<img>`
      #   inside the gallery. The block-based slot API takes precedence when
      #   images are added via `with_image`.
      #
      # @option kws css [String] Additional CSS classes for styling. Common
      #   options include sizing utilities such as `max-w-60` or `w-full`. Pass
      #   an `aspect-*` utility (e.g. `aspect-square`) to override the default
      #   3:2 aspect ratio.
      #
      def initialize(srcs: nil, **kws)
        super(**kws)
        @srcs = srcs
        @css = config_option(:css, "")
      end

      def before_render
        setup_component
        super
      end

      private

      def setup_component
        set_tag_name(:component, :figure)
        add_css(:component, "hover-gallery")

        # Default to a 3:2 aspect ratio so images with different aspect
        # ratios don't shift the gallery's height as each is revealed on
        # hover. The zero-specificity `where:` variant plus this guard keep
        # it easy to override; pass any `aspect-*` utility via `css:`.
        add_css(:component, "where:aspect-[3/2]") unless @css.include?("aspect-")
      end
    end
  end
end
