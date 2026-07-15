# frozen_string_literal: true

module LocoMotion
  #
  # Builder class for creating dynamic component subclasses with custom
  # configurations. This class encapsulates the complex metaprogramming logic
  # needed to create customized component instances without defining new
  # classes.
  #
  class ComponentBuilder
    attr_reader :base_class, :build_kws, :build_block

    #
    # Initialize a new component builder.
    #
    # @param base_class [Class] The base component class to build from.
    #
    # @param build_kws [Hash] Keyword arguments to merge into the component
    #   config.
    #
    # @param build_block [Proc] Optional block for customizations.
    #
    def initialize(base_class, build_kws = {}, &build_block)
      @base_class = base_class
      @build_kws = build_kws
      @build_block = build_block
      @build_counter = base_class.instance_variable_get(:@build_counter) || 0
    end

    #
    # Build the customized component subclass.
    #
    # @return [Class] The dynamically created component subclass.
    #
    def build
      klass = create_subclass
      setup_component_name(klass)
      setup_sidecar_files(klass)
      override_initialize(klass)
      apply_customizations(klass)
      increment_counter
      klass
    end

    private

    #
    # Create a named subclass of the base class.
    #
    # @return [Class] The dynamically created subclass.
    #
    def create_subclass
      klass_name = generate_class_name
      Class.new(base_class) do
        define_singleton_method(:name) do
          klass_name
        end
      end
    end

    #
    # Generate a unique class name for the subclass.
    #
    # @return [String] The generated class name.
    #
    def generate_class_name
      @build_counter += 1
      "#{base_class.name}__Build#{@build_counter}"
    end

    #
    # Set up the component name on the subclass for template lookup.
    #
    # @param klass [Class] The subclass to configure.
    #
    def setup_component_name(klass)
      superclass_component_name = base_class.instance_variable_get(:@component_name)
      return unless superclass_component_name

      klass.instance_variable_set(:@component_name, superclass_component_name)
    end

    #
    # Set up sidecar_files delegation to avoid issues with anonymous classes.
    #
    # @param klass [Class] The subclass to configure.
    #
    def setup_sidecar_files(klass)
      return if klass.method_defined?(:sidecar_files)

      klass.instance_eval do
        def sidecar_files(*args)
          superclass.sidecar_files(*args)
        end
      end
    end

    #
    # Override the initialize method to merge build and instance arguments.
    #
    # @param klass [Class] The subclass to configure.
    #
    def override_initialize(klass)
      original_initialize = klass.method_defined?(:initialize) ? klass.instance_method(:initialize) : nil
      build_kws_copy = build_kws.dup

      klass.define_method(:initialize) do |*instance_args, **instance_kws, &instance_block|
        if original_initialize
          original_initialize.bind(self).call(*instance_args, **instance_kws, &instance_block)
        else
          super(*instance_args, **instance_kws, &instance_block)
        end

        # Merge build_kws into config after initialize
        @config.smart_merge!(**build_kws_copy) if instance_variable_defined?(:@config)

        # Update instance variables for build_kws
        build_kws_copy.each do |key, value|
          instance_var = "@#{key}"
          instance_variable_set(instance_var, value) if instance_variable_defined?(instance_var)
        end
      end
    end

    #
    # Apply customizations from the build block.
    #
    # @param klass [Class] The subclass to customize.
    #
    def apply_customizations(klass)
      klass.class_eval(&build_block) if build_block
    end

    #
    # Increment the build counter on the base class.
    #
    def increment_counter
      base_class.instance_variable_set(:@build_counter, @build_counter)
    end
  end
end
