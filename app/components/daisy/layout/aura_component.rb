# frozen_string_literal: true

module Daisy
  module Layout
    #
    # The AuraComponent wraps any content with the DaisyUI `aura` effect — an
    # animated border light that rotates around the element. Common use cases
    # include:
    # - Highlighting a call-to-action button.
    # - Drawing attention to a featured card or pricing section.
    # - Adding a subtle glow to avatars or badges.
    #
    # The effect is pure CSS: the wrapper paints a rotating conic gradient behind
    # your content (plus two blurred copies for the glow), so no JavaScript is
    # required. The gradient uses `currentColor`, which means the aura color is
    # simply the wrapper's text color — set it with any Tailwind `text-*` utility.
    #
    # Includes the {LocoMotion::Concerns::LinkableComponent} module so that
    # providing an `href:` will render the wrapper as an `<a>` tag, making the
    # entire aura-wrapped element clickable.
    #
    # @note The glow is drawn with blurred pseudo-elements that extend slightly
    #   outside the wrapper, so avoid `overflow-hidden` on the aura itself (or on
    #   a tight parent) or the glow will be clipped.
    #
    # @note Inside a column flex container (e.g. a card body on small screens),
    #   the wrapper is stretched to the parent's full width by the default
    #   `align-items: stretch`, painting the aura far beyond its content. Add
    #   `w-fit` (or an appropriate `self-*` utility) to keep the aura sized to
    #   its content.
    #
    # @loco_example Basic Usage
    #   = daisy_aura do
    #     = daisy_card(css: "bg-base-100") do
    #       %p This card has aura!
    #
    # @loco_example Aura Variants
    #   = daisy_aura(css: "aura-rainbow") do
    #     = daisy_card(css: "bg-base-100") do
    #       %p Rainbow aura
    #
    # @loco_example Aura Around a Button
    #   = daisy_aura do
    #     = daisy_button(title: "Highlighted Action", css: "btn-primary")
    #
    # @loco_example Custom Color
    #   = daisy_aura(css: "text-orange-600") do
    #     = daisy_card(css: "bg-base-100 text-base-content") do
    #       %p Custom color aura
    #
    # @loco_example Clickable Aura
    #   = daisy_aura(href: "/pricing", css: "aura-gold cursor-pointer") do
    #     = daisy_card(css: "bg-base-100") do
    #       %p Click to view pricing
    #
    class AuraComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::LinkableComponent

      #
      # Creates a new Aura component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws css [String] Additional CSS classes for styling. Common
      #   options include:
      #   - Style: `aura-dual`, `aura-rainbow`, `aura-holo`, `aura-gold`,
      #     `aura-silver`, `aura-glow`
      #   - Size: `aura-xs`, `aura-sm`, `aura-md`, `aura-lg`, `aura-xl`
      #   - Color: any `text-*` utility (the effect renders in `currentColor`)
      #
      # @option kws href [String] When provided, the wrapper renders as an
      #   `<a>` tag so the entire aura-wrapped element is clickable.
      #
      # @option kws target [String] The link target (e.g., `_blank`). Only
      #   applied when `href:` is also provided.
      #
      def initialize(*args, **kws, &block)
        super
      end

      #
      # Sets up the component's CSS classes.
      #
      def before_render
        setup_component
        super
      end

      private

      def setup_component
        add_css(:component, "aura")
      end
    end
  end
end
