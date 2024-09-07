module LocoMotion
  class UnknownPartError < StandardError
    def initialize(part, component, custom_message = nil)
      no_parts_explanation = "No parts are defined on the component."
      default_explanation = "Valid parts are #{component.config.valid_parts.map(&:inspect).to_sentence}."

      has_parts = component.config.valid_parts.present?

      default_message = [
        "Unknown part #{part.inspect}.",
        "#{has_parts ? default_explanation : no_parts_explanation}"
      ].join(' ')

      super(custom_message || default_message)
    end
  end

  class InvalidModifierError < StandardError
    def initialize(modifier, component, custom_message = nil)
      no_modifiers_explanation = "No modifiers are defined on the component."
      default_explanation = "Valid modifiers are #{component.valid_modifiers.map(&:inspect).to_sentence}."

      has_modifiers = component.valid_modifiers.present?

      default_message = [
        "Unknown modifier #{modifier.inspect}.",
        "#{has_modifiers ? default_explanation : no_modifiers_explanation}"
      ].join(' ')

      super(custom_message || default_message)
    end
  end
end
