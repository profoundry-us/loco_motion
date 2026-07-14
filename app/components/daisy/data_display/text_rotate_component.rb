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
    # @part wrapper The container that wraps all of the rotated items.
    #
    # @slot item+ Multiple text items to display in the rotation. Each item will
    #   be displayed one at a time in an infinite loop.
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
        # Creates a new Text Rotate item.
        #
        # @param kws [Hash] The keyword arguments for the component.
        #
        # @option kws href [String] A path or URL to which the user will be
        #   directed when the item is clicked. Forces the item to use an
        #   `<a>` tag.
        #
        # @option kws target [String] The HTML `target` attribute for the
        #   `<a>` tag (`_blank`, `_parent`, or a specific tab / window /
        #   iframe, etc).
        #
        # @option kws title [String] The HTML `title` attribute for the
        #   `<a>` tag, shown as a native tooltip on hover. Only applied when
        #   `href` is also provided.
        #
        # @option kws turbo_frame [String] The Turbo Frame to target,
        #   rendered as `data-turbo-frame`.
        #
        # @option kws turbo_action [String, Symbol] How Turbo Drive updates
        #   the browser history for the visit, rendered as
        #   `data-turbo-action` (e.g. `:advance` or `:replace`).
        #
        # @option kws turbo_method [String, Symbol] The HTTP method Turbo
        #   should use for the request, rendered as `data-turbo-method`
        #   (e.g. `:delete`).
        #
        # @option kws turbo_confirm [String] A confirmation prompt Turbo
        #   shows before submitting, rendered as `data-turbo-confirm`.
        #
        # @option kws action [String] A Stimulus action wired to the item via
        #   its `data-action` attribute. Stimulus infers the `click` event,
        #   so `action: "my-controller#handle"` works as a shorthand for
        #   `action: "click->my-controller#handle"`.
        #
        # @option kws icon [String] The icon to render, as a qualified
        #   `[library:]name[/variant]` token. This is an alias of
        #   `left_icon`.
        #
        # @option kws icon_css [String] The CSS classes to apply to the
        #   icon. This is an alias of `left_icon_css`.
        #
        # @option kws icon_options [Hash] Additional keyword arguments
        #   forwarded to the icon component. This is an alias of
        #   `left_icon_options`.
        #
        # @option kws icon_html [Hash] Additional HTML attributes to apply
        #   to the icon. This is an alias of `left_icon_html`.
        #
        # @option kws left_icon [String] The icon to render to the left of
        #   the content, as a qualified `[library:]name[/variant]` token.
        #
        # @option kws left_icon_css [String] The CSS classes to apply to the
        #   left icon.
        #
        # @option kws left_icon_options [Hash] Additional keyword arguments
        #   forwarded to the left icon component (e.g. `tip:`).
        #
        # @option kws left_icon_html [Hash] Additional HTML attributes to
        #   apply to the left icon.
        #
        # @option kws right_icon [String] The icon to render to the right of
        #   the content, as a qualified `[library:]name[/variant]` token.
        #
        # @option kws right_icon_css [String] The CSS classes to apply to
        #   the right icon.
        #
        # @option kws right_icon_options [Hash] Additional keyword arguments
        #   forwarded to the right icon component (e.g. `tip:`).
        #
        # @option kws right_icon_html [Hash] Additional HTML attributes to
        #   apply to the right icon.
        #
        # rubocop:disable Lint/UselessMethodDefinition
        def initialize(**kws, &block)
          super
        end
        # rubocop:enable Lint/UselessMethodDefinition

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
      # @param texts [Array<String>] An optional array of strings for
      #   simple usage.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws [String] :wrapper_css CSS classes to apply to the
      #   wrapper part that surrounds all of the rotated items.
      #
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
