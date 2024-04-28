module LocoMotion
  class InvalidModifierError < StandardError
    def initialize(modifier, component, custom_message = nil)
      no_modifiers_explanation = "No modifiers are defined on the component."
      default_explanation = "Valid modifiers are #{component.valid_modifiers.to_sentence}."

      has_modifiers = component.valid_modifiers.present?

      default_message = [
        "Unknown modifier `#{modifier.inspect}`.",
        "#{has_modifiers ? default_explanation : no_modifiers_explanation}"
      ].join(' ')

      super(custom_message || default_message)
    end
  end
end
