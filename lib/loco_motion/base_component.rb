class LocoMotion::BaseComponent < ViewComponent::Base

  class_attribute :component_parts, default: { component: {} }
  # TODO: Determine whether or not the stimulus stuff should be part of the
  # component definition, or part of the after-init configuration.
  class_attribute :stimulus_controllers, default: []
  class_attribute :variants, default: []

  #
  # Return the current configruation of this component.
  #
  # @return LocoMotion::ComponentConfig
  #
  attr_reader :config

  #
  # Create a new instance of a component.
  #
  def initialize(*args, **kws, &block)
    super

    # Create our config object
    @config = LocoMotion::ComponentConfig.new(self, **kws, &block)
  end

  #
  # Defines a new part of this component which can customize CSS, HTML and more.
  #
  def self.define_part(part_name, part_defaults = {})
    # Note that since we're using Rails' class_attribute method for these, we
    # must take care not to alter the original object but rather use a setter
    # (the `=` in this case) to set the new value so Rails knows not to override
    # the parent value.
    #
    # For example, we cannot use `merge!` or `[part_name] = ` here.
    self.component_parts = component_parts.merge({ part_name => part_defaults })
  end

  #
  # Defines a single variant of this component. Variants control certain
  # rendering aspects of the component.
  #
  # @param variant_name [Symbol] The name of the variant.
  #
  def self.define_variant(variant_name)
    define_variants(variant_name)
  end

  #
  # Define multiple variants for this component. Variants control certain
  # rendering aspects of the component.
  #
  # @param variant_names [Array[Symbol]] An array of the variant names you wish
  #   to define.
  #
  def self.define_variants(*variant_names)
    # Note that since we're using Rails' class_attribute method for these, we
    # must take care not to alter the original object but rather use a setter
    # (the `+=` in this case) to set the new value so Rails knows not to
    # override the parent value.
    #
    # For example, we cannot use `<<` or `concat` here.
    self.variants ||= []
    self.variants += variant_names
  end

  #
  # Add a Stimulus (Javascript) controller to this component.
  #
  def self.add_stimulus_controller(part_name, controller_name)
    self.stimulus_controllers ||= {}
    self.stimulus_controllers[part_name] = controller_name
  end

  #
  # Returns a reference to this component. Useful for passing a parent component
  # into child components.
  #
  # @return [BaseComponent] A reference to this component.
  #
  def component_ref
    self
  end

end
