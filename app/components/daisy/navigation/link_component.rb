# frozen_string_literal: true

module Daisy
  module Navigation
    #
    # Creates a styled link component that can be used for navigation or inline
    # text links. This component is designed to work similarly to Rails'
    # `link_to` helper.
    #
    # @loco_example Link with positional arguments
    #   = daisy_link "Documentation", "#"
    #
    # @loco_example Basic link with keyword arguments
    #   = daisy_link(title: "Home", href: "#")
    #
    # @loco_example Link with custom styling
    #   = daisy_link "Components", "#", css: "link-primary text-xl"
    #
    # @loco_example Link with block content
    #   = daisy_link "#", css: "link-hover" do
    #     = loco_icon("home")
    #     Home
    #
    # @loco_example Link with icon
    #   = daisy_link(title: "Home", href: "#", icon: "home")
    #
    # @loco_example Link with left and right icons
    #   = daisy_link(title: "Navigate", href: "#", left_icon: "arrow-left", right_icon: "arrow-right")
    #
    # @loco_example Link driving a Stimulus action
    #   = daisy_link(title: "Toggle", href: "#", action: "click->my-controller#toggle")
    #
    class LinkComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::TippableComponent
      include LocoMotion::Concerns::LinkableComponent
      include LocoMotion::Concerns::IconableComponent

      # Create a new instance of the LinkComponent.
      #
      # @param args [Array] Looks for **one** or **two** positional arguments.
      #   - If passed **two** positional arguments, the first is considered the
      #   `title` and the second is considered the `href`.
      #   - If passed only **one** positional argument, it is treated as the
      #   `href` and we assume the `title` will be provided in the block.
      #   - If no text is passed in the block, we will use the `href` as the
      #   title.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws title [String] The text to display in the link. Not required
      #   if providing block content.
      #
      # @option kws href [String] The URL to visit when the link is clicked.
      #
      # @option kws target [String] The target attribute for the anchor tag
      #   (e.g., "_blank").
      #
      # @option kws action [String] A Stimulus action wired to the link via its
      #   `data-action` attribute (provided by
      #   {LocoMotion::Concerns::ActionableComponent}). Stimulus infers the
      #   `click` event, so `action: "my-controller#handle"` is shorthand for
      #   `action: "click->my-controller#handle"`. Have the controller call
      #   `event.preventDefault()` (or omit `href`) when the link only drives a
      #   controller rather than navigating.
      #
      # @option kws turbo_frame [String] The Turbo Frame to target, rendered as
      #   `data-turbo-frame`.
      #
      # @option kws turbo_action [String, Symbol] How Turbo Drive updates the
      #   browser history for the visit, rendered as `data-turbo-action`
      #   (e.g. `:advance` or `:replace`).
      #
      # @option kws turbo_method [String, Symbol] The HTTP method Turbo should
      #   use for the request, rendered as `data-turbo-method` (e.g. `:delete`).
      #
      # @option kws turbo_confirm [String] A confirmation prompt Turbo shows
      #   before submitting, rendered as `data-turbo-confirm`.
      #
      # @option kws icon [String] The name of Hero icon to render inside the
      #   link. This is an alias of `left_icon`.
      #
      # @option kws icon_css [String] The CSS classes to apply to the icon.
      #   This is an alias of `left_icon_css`.
      #
      # @option kws icon_html [Hash] Additional HTML attributes to apply to
      #   the icon. This is an alias of `left_icon_html`.
      #
      # @option kws left_icon [String] The name of Hero icon to render inside
      #   the link to the left of the text.
      #
      # @option kws left_icon_css [String] The CSS classes to apply to the left
      #   icon.
      #
      # @option kws left_icon_html [Hash] Additional HTML attributes to apply to
      #   the left icon.
      #
      # @option kws right_icon [String] The name of Hero icon to render inside
      #   the link to the right of the text.
      #
      # @option kws right_icon_css [String] The CSS classes to apply to the
      #   right icon.
      #
      # @option kws right_icon_html [Hash] Additional HTML attributes to apply
      #   to the right icon.
      #
      # @option kws css [String] Additional CSS classes for styling. Common
      #   options include:
      #   - Style: `link-primary`, `link-secondary`, `link-accent`
      #   - State: `link-hover`
      #   - Text: `text-sm`, `text-xl`, `text-2xl`
      #
      # @option kws tip [String] The tooltip text to display when hovering over
      #   the component.
      #
      def initialize(*args, **kws)
        super

        if args.size == 1
          # If given one arg, assume it's the href and / or the title
          # (if no block is given)
          @title = args[0]
          @href = args[0]
        elsif args.size == 2
          # If given two args, assume the first is the title and the second is
          # the href
          @title = args[0]
          @href = args[1]
        else
          # Otherwise, assume they pass everything as keyword arguments
          @title = config_option(:title)
          @href = config_option(:href)
        end

        @target = config_option(:target)
      end

      #
      # Adds the relevant Daisy classes and applies the href and target
      # attributes if provided.
      #
      def before_render
        super

        setup_component
      end

      #
      # Renders the link component.
      #
      # Because this is an inline component which might be utilized alongside
      # text, we utilize the `call` method instead of a template to ensure that
      # no additional whitespace gets added to the output.
      #
      def call
        if content?
          part(:component) { content }
        else
          part(:component) do
            concat(render_left_icon)
            concat(@title)
            concat(render_right_icon)
          end
        end
      end

      private

      def setup_component
        add_css(:component, "link")
      end
    end
  end
end
