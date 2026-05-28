require "active_support/concern"

module LocoMotion
  module Concerns
    #
    # The AriableComponent concern wires up sensible default `aria-*`
    # attributes for components (primarily form inputs) so that authors and
    # users don't have to set them by hand.
    #
    # It is intentionally conservative: native HTML controls already expose
    # most of their semantics (checked, disabled, required, etc.) to assistive
    # technology, so this concern only fills in attributes that are commonly
    # expected and never overrides anything the user passed explicitly via the
    # `aria:` shortcut or `*_html` options.
    #
    # **Current behavior**
    #
    # - When the component's `required` option is truthy, adds
    #   `aria-required="true"` (unless the user already set `aria-required`).
    #
    # Users can always set or override any `aria-*` attribute using the `aria:`
    # shortcut, e.g. `daisy_text_input(aria: { describedby: "email-help" })`.
    #
    # @loco_example Including the concern in a component
    #   class MyInputComponent < LocoMotion::BaseComponent
    #     include LocoMotion::Concerns::AriableComponent
    #     # component implementation ...
    #   end
    #
    module AriableComponent
      extend ActiveSupport::Concern

      included do |base|
        base.register_component_setup(:_setup_ariable_component)
      end

      protected

      #
      # Applies the default `aria-*` attributes for the component. Called
      # automatically during the render lifecycle.
      #
      def _setup_ariable_component
        _setup_ariable_required
      end

      #
      # Mirrors a truthy `required` option as `aria-required="true"` unless the
      # user explicitly provided an `aria-required` value.
      #
      def _setup_ariable_required
        return unless config_option(:required)
        return if _ariable_user_set?(:required)

        add_aria(:component, required: true)
      end

      #
      # Determines whether the user explicitly supplied an `aria-{key}`
      # attribute for the component part, in either the nested
      # (`aria: { key: ... }`) or dasherized (`"aria-key"`) form, so we avoid
      # overriding their intent or rendering duplicate attributes.
      #
      # @param key [Symbol] The aria attribute name without the `aria-` prefix.
      #
      # @return [Boolean]
      #
      def _ariable_user_set?(key)
        user_html = config.get_part(:component)[:user_html] || {}
        nested = user_html[:aria] || user_html["aria"] || {}

        nested.key?(key) || nested.key?(key.to_s) ||
          user_html.key?(:"aria-#{key}") || user_html.key?("aria-#{key}")
      end
    end
  end
end
