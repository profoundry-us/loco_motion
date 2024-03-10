module LocoMotion
  class InvalidVariantError < StandardError
    def initialize(variant, component, custom_message = nil)
      default_message = "Unknown variant `#{variant.inspect}`. Valid variants are #{component.valid_variants.to_sentence}."

      super(custom_message || default_message)
    end
  end
end
