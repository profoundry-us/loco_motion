# frozen_string_literal: true

module Daisy
  module DataDisplay
    #
    # The Text Rotate component displays up to 6 lines of text, one at a time,
    # with an infinite loop CSS animation. The duration is 10 seconds by default
    # and the animation pauses on hover. Common use cases include rotating hero
    # headlines, cycling through feature keywords, or animating taglines on
    # marketing pages.
    #
    # @slot item+ Multiple text items to display in the rotation. Each item will
    #   be displayed one at a time in an infinite loop.
    #
    # @param texts [Array<String>] An optional array of strings for simple usage
    #   without blocks. When provided, each string is rendered as a span inside
    #   the rotation.
    #
    # @loco_example Basic Text Rotate
    #   = daisy_text_rotate do |rotate|
    #     - rotate.with_item { "ONE" }
    #     - rotate.with_item { "TWO" }
    #     - rotate.with_item { "THREE" }
    #
    # @loco_example Text Rotate with texts Shorthand
    #   = daisy_text_rotate(texts: %w[DESIGN DEVELOP DEPLOY SCALE MAINTAIN REPEAT], css: "text-7xl")
    #
    # @loco_example Text Rotate with Centered Items
    #   = daisy_text_rotate(css: "text-7xl", wrapper_css: "justify-items-center") do |rotate|
    #     - rotate.with_item { "DESIGN" }
    #     - rotate.with_item { "DEVELOP" }
    #     - rotate.with_item { "DEPLOY" }
    #
    # @loco_example Text Rotate with Custom Duration
    #   = daisy_text_rotate(css: "text-7xl duration-6000") do |rotate|
    #     - rotate.with_item { "BLAZING" }
    #     - rotate.with_item(css: "font-bold italic") { "FAST" }
    #
    # @loco_example Text Rotate with Icons and Links
    #   = daisy_text_rotate(css: "text-7xl") do |rotate|
    #     - rotate.with_item(left_icon: "sparkles") { "DESIGN" }
    #     - rotate.with_item(href: "https://example.com", right_icon: "arrow-top-right-on-square") { "DEVELOP" }
    #
    # @loco_example Text Rotate with Custom Content
    #   = daisy_text_rotate(css: "text-7xl") do
    #     %span.text-rotate-item.text-primary CUSTOM
    #     %span.text-rotate-item.text-secondary CONTENT
    #
    class TextRotateComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::TippableComponent

      set_component_name :text_rotate

      define_part :wrapper, tag_name: :span

      #
      # Renders an individual text item within the rotation. Supports optional
      # links (via {LocoMotion::Concerns::LinkableComponent}) and icons (via
      # {LocoMotion::Concerns::IconableComponent}).
      #
      class ItemComponent < LocoMotion::BasicComponent
        include LocoMotion::Concerns::LinkableComponent
        include LocoMotion::Concerns::IconableComponent

        #
        # Runs item-specific setup before rendering. Runs before `super` so that
        # LinkableComponent can override the tag name to `<a>` when an href is set.
        #
        def before_render
          setup_component

          super
        end

        #
        # Renders the item, including optional left/right icons around the content.
        #
        def call
          part(:component) do
            concat(render_left_icon)
            concat(content)
            concat(render_right_icon)
          end
        end

        private

        def setup_component
          set_tag_name(:component, :span)
          add_css(:component, "text-rotate-item")
        end
      end

      renders_many :items, ItemComponent

      attr_reader :texts

      #
      # Creates a new Text Rotate component.
      #
      # @param texts [Array<String>] An optional array of strings for simple usage.
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws [String] :wrapper_css CSS classes to apply to the wrapper part
      #   that surrounds all of the rotated items.
      # @option kws [String] :tip The tooltip text to display when hovering over
      #   the component.
      #
      def initialize(texts: nil, **kws, &block)
        super(**kws, &block)

        @texts = texts
      end

      def before_render
        super

        setup_component
        setup_texts if texts
      end

      private

      def setup_component
        set_tag_name(:component, :span)
        add_css(:component, "text-rotate")
      end

      def setup_texts
        texts.each do |text|
          with_item { text }
        end
      end
    end
  end
end
