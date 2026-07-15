# frozen_string_literal: true

module LocoMotion
  module Concerns
    #
    # Provides a formatted inspect method for components
    #
    # This concern offers a shared way to build readable inspect strings
    # for components and configuration objects using format strings.
    #
    module InspectableComponent
      #
      # Builds a formatted inspect string from the given attribute names.
      #
      # @param attributes [Array<Symbol>] The attribute names to include in the inspect output
      # @param suffix [String] Optional suffix to append (default: ">")
      # @return [String] The formatted inspect string
      #
      def build_inspect_string(*attributes, suffix: ">")
        format("#<%<class>s %<attributes>s%<suffix>s",
               class: self.class.name,
               attributes: attributes.map { |attr| "@#{attr}=#{send(attr).inspect}" }.join(" "),
               suffix: suffix)
      end
    end
  end
end
