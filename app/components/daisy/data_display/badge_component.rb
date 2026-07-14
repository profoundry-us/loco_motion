# frozen_string_literal: true

module Daisy
  module DataDisplay
    #
    # The Badge component renders as a small, rounded element used to display status,
    # labels, or notifications. It supports various background colors and can be used
    # inline with text.
    #
    # Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
    # tooltip addition.
    #
    # @loco_example Basic Usage
    #   = daisy_badge("New!")
    #
    # @loco_example With Different Colors
    #   = daisy_badge("Primary", css: "badge-primary")
    #   = daisy_badge("Secondary", css: "badge-secondary")
    #   = daisy_badge("Accent", css: "badge-accent")
    #   = daisy_badge("Ghost", css: "badge-ghost")
    #
    # @loco_example With Tooltip
    #   = daisy_badge("Beta", tip: "This feature is in beta testing")
    #
    # @loco_example With Icons
    #   = daisy_badge(title: "New", left_icon: "sparkles")
    #   = daisy_badge(title: "Download", right_icon: "arrow-down")
    #   = daisy_badge(title: "Star", left_icon: "star", right_icon: "plus")
    #
    # @loco_example With Links
    #   = daisy_badge(title: "Documentation", href: "#", css: "badge-primary")
    #   = daisy_badge(title: "External", href: "#", target: "_blank", css: "badge-secondary")
    #   = daisy_badge(title: "GitHub", href: "#", left_icon: "code-bracket")
    #
    # @loco_example Using a Block
    #   = daisy_badge do
    #     %span.flex.items-center.gap-1
    #       = loco_icon("star", css: "size-4")
    #       Featured
    #
    # @loco_example With Status Colors
    #   = daisy_badge("Info", css: "badge-info")
    #   = daisy_badge("Success", css: "badge-success")
    #   = daisy_badge("Warning", css: "badge-warning")
    #   = daisy_badge("Error", css: "badge-error")
    #
    # @loco_example With Style Variants
    #   = daisy_badge("Outline", css: "badge-primary badge-outline")
    #   = daisy_badge("Soft", css: "badge-primary badge-soft")
    #   = daisy_badge("Dash", css: "badge-primary badge-dash")
    #
    class BadgeComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::IconableComponent
      include LocoMotion::Concerns::LinkableComponent
      include LocoMotion::Concerns::TippableComponent

      set_component_name :badge

      #
      # Create a new Badge component.
      #
      # @param title [String] The text to display in the badge. You can also pass
      #   the title as a keyword argument or provide content via a block.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws title [String] The text to display in the badge. You can
      #   also pass the title as the first argument or provide content via a
      #   block.
      #
      # @option kws href [String] A path or URL to which the user will be
      #   directed when the badge is clicked. Forces the Badge to use an
      #   `<a>` tag.
      #
      # @option kws target [String] The HTML `target` attribute for the `<a>`
      #   tag (`_blank`, `_parent`, or a specific tab / window / iframe, etc).
      #
      # @option kws turbo_frame [String] The Turbo Frame to target, rendered
      #   as `data-turbo-frame`.
      #
      # @option kws turbo_action [String, Symbol] How Turbo Drive updates the
      #   browser history for the visit, rendered as `data-turbo-action`
      #   (e.g. `:advance` or `:replace`).
      #
      # @option kws turbo_method [String, Symbol] The HTTP method Turbo
      #   should use for the request, rendered as `data-turbo-method`
      #   (e.g. `:delete`).
      #
      # @option kws turbo_confirm [String] A confirmation prompt Turbo shows
      #   before submitting, rendered as `data-turbo-confirm`.
      #
      # @option kws action [String] A Stimulus action wired to the badge via
      #   its `data-action` attribute. Stimulus infers the `click` event, so
      #   `action: "my-controller#handle"` works as a shorthand for
      #   `action: "click->my-controller#handle"`.
      #
      # @option kws icon [String] The icon to render inside the badge, as a
      #   qualified `[library:]name[/variant]` token. This is an alias of
      #   `left_icon`.
      #
      # @option kws icon_css [String] The CSS classes to apply to the icon.
      #   This is an alias of `left_icon_css`.
      #
      # @option kws icon_options [Hash] Additional keyword arguments
      #   forwarded to the icon component. This is an alias of
      #   `left_icon_options`.
      #
      # @option kws icon_html [Hash] Additional HTML attributes to apply to the
      #   icon. This is an alias of `left_icon_html`.
      #
      # @option kws left_icon [String] The icon to render inside the badge to
      #   the left of the text, as a qualified `[library:]name[/variant]`
      #   token.
      #
      # @option kws left_icon_css [String] The CSS classes to apply to the left
      #   icon.
      #
      # @option kws left_icon_options [Hash] Additional keyword arguments
      #   forwarded to the left icon component (e.g. `tip:`).
      #
      # @option kws left_icon_html [Hash] Additional HTML attributes to apply to
      #   the left icon.
      #
      # @option kws right_icon [String] The icon to render inside the badge to
      #   the right of the text, as a qualified `[library:]name[/variant]`
      #   token.
      #
      # @option kws right_icon_css [String] The CSS classes to apply to the
      #   right icon.
      #
      # @option kws right_icon_options [Hash] Additional keyword arguments
      #   forwarded to the right icon component (e.g. `tip:`).
      #
      # @option kws right_icon_html [Hash] Additional HTML attributes to apply
      #   to the right icon.
      #
      def initialize(title = nil, **kws, &block)
        super

        @simple_title = config_option(:title, title)
      end

      def before_render
        # Run component setup *before* super to allow LinkableComponent to override tag
        setup_component

        super
      end

      #
      # Renders the badge component.
      #
      # Because this is an inline component which might be utilized alongside
      # text, we utilize the `call` method instead of a template to ensure that
      # no additional whitespace gets added to the output.
      #
      def call
        part(:component) do
          concat(render_left_icon)
          concat(content || @simple_title)
          concat(render_right_icon)
        end
      end

      private

      # DaisyUI's `.badge` is already a centered inline-flex row with the
      # same 0.5rem gap, so Iconable's root classes are redundant here.
      def iconable_root_css; end

      def setup_component
        set_tag_name(:component, :span)
        add_css(:component, "badge")
      end
    end
  end
end
