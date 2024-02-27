class LocoMotion::BaseComponent < ViewComponent::Base

  #
  # Defines a new part of this component which can customize CSS, HTML and more.
  #
  def self.define_part(part_name, options = {})
    @parts ||= {}

    @parts[part_name] = options
  end

  #
  # List all of the parts of this component.
  #
  # @returns Hash
  #
  def self.parts
    @parts
  end

  #
  # Define a variant for this component. Variants control certain rendering
  # aspects of the component.
  #
  def self.define_variant(variant_name, options = {})
    @variants ||= {}

    @variants[variant_name] = options
  end

  #
  # List all of the available variants of this component.
  #
  # @returns Hash
  #
  def self.variants
    @variants
  end

  def self.add_stimulus(part_name, controller_name)
  end
end
