# frozen_string_literal: true

require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # Can be included in any component to provide a first-class `sticky`
    # keyword option: the component gets `position: sticky` and LocoMotion's
    # `loco-sticky` Stimulus controller, which stamps `data-stuck="<edges>"` on
    # it while it is actually pinned so `loco.css`'s `stuck:` variants can
    # style the pinned state (`py-4 stuck:py-1`). This mirrors the way
    # {TurboableComponent} sugars the `data-turbo-*` attributes.
    #
    # | Option    | Effect                                                    |
    # |-----------|-----------------------------------------------------------|
    # | `sticky`  | `sticky` class, `loco-sticky` controller, and its `edge`  |
    #
    # Everything lands on the component's root part by default; a component
    # whose pinned element is an inner part overrides {#sticky_part} (a table
    # head pins its `<tr>`).
    #
    # The **offset is yours to set** via `css:` (`top-0`, `top-16`, `left-0`).
    # The concern deliberately never emits one: Tailwind resolves competing
    # utilities by stylesheet order, so a concern-emitted `top-0` could
    # unpredictably beat your `top-16`. The controller reads the offset back
    # from the element's computed style, so nothing is declared twice.
    #
    # @loco_example A navbar that compacts once it pins
    #   = daisy_navbar(sticky: "top", css: "top-0 py-4 stuck:py-1 transition-[padding]") do |navbar|
    #     - navbar.with_leading do
    #       = image_tag("logo.png", class: "h-8 stuck:h-6 transition-[height]")
    #
    # @loco_example Pinning to another edge, or to two at once
    #   = daisy_navbar(sticky: "bottom", css: "bottom-0")
    #   = daisy_navbar(sticky: ["top", "left"], css: "top-0 left-0")
    #
    module StickableComponent
      extend ActiveSupport::Concern

      EDGES = %w[top bottom left right].freeze

      included do |base|
        base.register_component_initializer(:_initialize_stickable_component)
        base.register_component_setup(:_setup_stickable_component)
      end

      #
      # Whether this component was asked to stick to at least one edge.
      #
      # @return [Boolean]
      #
      def sticky?
        @sticky_edges.any?
      end

      #
      # The edges this component sticks to, in the order given.
      #
      # @return [Array<String>] A subset of `top`, `bottom`, `left`, `right`.
      #
      def sticky_edges
        @sticky_edges
      end

      protected

      #
      # Initialize the sticky option.
      #
      # @option kws sticky [String, Symbol, Array<String, Symbol>, Boolean] The
      #   edge(s) the component pins to: `"top"` (or `true`), `"bottom"`,
      #   `"left"`, `"right"`, or several as an array or space-separated
      #   string (`["top", "left"]` for a corner cell). Set the matching offset
      #   utility yourself via `css:` (e.g. `top-0`). Off when omitted.
      #
      def _initialize_stickable_component
        @sticky_edges = normalize_sticky_edges(config_option(:sticky))
      end

      #
      # Configure sticky positioning: the `sticky` class, the `loco-sticky`
      # controller, and — only when the edges differ from the controller's
      # default of `top` — its `edge` value. Nothing is emitted when `sticky`
      # was not requested.
      #
      def _setup_stickable_component
        return unless sticky?

        add_css(sticky_part, "sticky")
        add_stimulus_controller(sticky_part, "loco-sticky")

        return if @sticky_edges == ["top"]

        add_html(sticky_part, { data: { loco_sticky_edge_value: @sticky_edges.join(" ") } })
      end

      #
      # The part that actually sticks (and carries the controller). Defaults to
      # the component's root; override when the pinned element is an inner
      # part — a table head pins its `<tr>`, not the `<thead>`, so it returns
      # `:row`.
      #
      # @return [Symbol] A part name.
      #
      def sticky_part
        :component
      end

      #
      # Turn the many accepted spellings of the option into a clean list of
      # edges, rejecting anything the controller would not understand.
      #
      # @raise [ArgumentError] When an edge is not one of {EDGES}.
      #
      def normalize_sticky_edges(value)
        return [] if value.nil? || value == false
        return ["top"] if value == true

        edges = Array(value).flat_map { |edge| edge.to_s.split(/\s+/) }.map(&:downcase).uniq
        invalid = edges - EDGES

        if invalid.any?
          raise ArgumentError,
                "Invalid sticky edge#{'s' if invalid.many?} #{invalid.join(', ')}; " \
                "expected one or more of #{EDGES.join(', ')}"
        end

        edges
      end
    end
  end
end
