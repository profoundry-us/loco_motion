# frozen_string_literal: true

module LocoMotion
  #
  # Raised when a component is asked to operate on a part (e.g. via
  # {LocoMotion::BaseComponent#part}, {LocoMotion::ComponentConfig#get_part},
  # or {LocoMotion::ComponentConfig#validate_part}) that isn't declared on
  # that component.
  #
  class UnknownPartError < StandardError
    #
    # @param part [Symbol] The unknown part name that was requested.
    #
    # @param component [LocoMotion::BaseComponent] The component instance
    #   the part was requested from, used to list its valid parts.
    #
    # @param custom_message [String, nil] An optional message to use instead
    #   of the generated default.
    #
    def initialize(part, component, custom_message = nil)
      no_parts_explanation = "No parts are defined on the component."
      default_explanation = "Valid parts are #{component.config.valid_parts.map(&:inspect).to_sentence}."

      has_parts = component.config.valid_parts.present?

      default_message = [
        "Unknown part #{part.inspect}.",
        (has_parts ? default_explanation : no_parts_explanation).to_s
      ].join(" ")

      super(custom_message || default_message)
    end
  end

  #
  # Raised when a component is given a modifier (via the `modifier:` /
  # `modifiers:` options) that isn't listed in that component's
  # `valid_modifiers`.
  #
  class InvalidModifierError < StandardError
    #
    # @param modifier [Symbol] The invalid modifier that was passed.
    #
    # @param component [LocoMotion::BaseComponent] The component instance
    #   the modifier was passed to, used to list its valid modifiers.
    #
    # @param custom_message [String, nil] An optional message to use instead
    #   of the generated default.
    #
    def initialize(modifier, component, custom_message = nil)
      no_modifiers_explanation = "No modifiers are defined on the component."
      default_explanation = "Valid modifiers are #{component.valid_modifiers.map(&:inspect).to_sentence}."

      has_modifiers = component.valid_modifiers.present?

      default_message = [
        "Unknown modifier #{modifier.inspect}.",
        (has_modifiers ? default_explanation : no_modifiers_explanation).to_s
      ].join(" ")

      super(custom_message || default_message)
    end
  end
end
