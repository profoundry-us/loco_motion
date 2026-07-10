# frozen_string_literal: true

require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # Can be included in linkable components to provide first-class keyword
    # options for the most common Turbo data attributes, instead of
    # hand-writing the nested `html: { data: { ... } }` hash. This mirrors the
    # way {TippableComponent} sugars `tip` over `data-tip`.
    #
    # | Option           | Emitted attribute    |
    # |------------------|----------------------|
    # | `turbo_frame`    | `data-turbo-frame`   |
    # | `turbo_action`   | `data-turbo-action`  |
    # | `turbo_method`   | `data-turbo-method`  |
    # | `turbo_confirm`  | `data-turbo-confirm` |
    #
    # Each attribute is only emitted when its option is provided, and anything
    # passed explicitly via `html: { data: { ... } }` still takes precedence
    # (user HTML is deep-merged over these defaults).
    #
    module TurboableComponent
      extend ActiveSupport::Concern

      included do |base|
        base.register_component_initializer(:_initialize_turboable_component)
        base.register_component_setup(:_setup_turboable_component)
      end

      protected

      #
      # Initialize Turbo-related options.
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
      def _initialize_turboable_component
        @turbo_frame = config_option(:turbo_frame)
        @turbo_action = config_option(:turbo_action)
        @turbo_method = config_option(:turbo_method)
        @turbo_confirm = config_option(:turbo_confirm)
      end

      #
      # Configure Turbo functionality for the component. Adds each
      # `data-turbo-*` attribute only when its corresponding option was
      # provided, so no empty attributes are rendered.
      #
      def _setup_turboable_component
        data = {}
        data[:turbo_frame] = @turbo_frame if @turbo_frame
        data[:turbo_action] = @turbo_action if @turbo_action
        data[:turbo_method] = @turbo_method if @turbo_method
        data[:turbo_confirm] = @turbo_confirm if @turbo_confirm

        add_html(:component, { data: data }) if data.any?
      end
    end
  end
end
