# frozen_string_literal: true

require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # Can be included in linkable components to provide a first-class `action`
    # keyword option — Stimulus `data-action` sugar — instead of hand-writing
    # the nested `html: { data: { action: ... } }` hash. This mirrors the way
    # {TurboableComponent} sugars the `data-turbo-*` attributes, and is pulled
    # in for every linkable component by {LinkableComponent}.
    #
    # | Option    | Emitted attribute |
    # |-----------|-------------------|
    # | `action`  | `data-action`     |
    #
    # Stimulus infers the `click` event for both `<button>` and `<a>`, so
    # `action: "my-controller#handle"` is shorthand for
    # `action: "click->my-controller#handle"`. The attribute is only emitted
    # when `action` is provided, and anything passed explicitly via
    # `html: { data: { action: ... } }` still takes precedence (user HTML is
    # deep-merged over this default).
    #
    # The attribute is written in the nested `data: { action: ... }` form (not a
    # flat `"data-action"` key) so it deep-merges cleanly alongside the
    # `data-controller` and `data-turbo-*` attributes other concerns add to the
    # same element, rather than colliding into a duplicate attribute.
    #
    module ActionableComponent
      extend ActiveSupport::Concern

      included do |base|
        base.register_component_initializer(:_initialize_actionable_component)
        base.register_component_setup(:_setup_actionable_component)
      end

      protected

      #
      # Initialize the action option.
      #
      # @option kws action [String] A Stimulus action wired to the component via
      #   its `data-action` attribute (e.g. `"click->my-controller#handle"`).
      #   Stimulus infers the `click` event, so `"my-controller#handle"` works as
      #   a shorthand.
      #
      def _initialize_actionable_component
        @action = config_option(:action)
      end

      #
      # Configure the Stimulus action for the component. Adds the `data-action`
      # attribute only when the `action` option was provided, so no empty
      # attribute is rendered.
      #
      def _setup_actionable_component
        add_html(:component, { data: { action: @action } }) if @action
      end
    end
  end
end
