class LocoMotion::BaseComponent < ViewComponent::Base

  SELF_CLOSING_TAGS = %i[area base br col embed hr img input keygen link meta param source track wbr].freeze
  EMPTY_PART_IGNORED_TAGS = %i[textarea].freeze

  include Heroicons::IconsHelper

  class_attribute :component_name
  class_attribute :component_parts, default: { component: {} }
  class_attribute :valid_modifiers, default: []
  class_attribute :valid_sizes, default: []

  # Hooks for concerns to register initialization and setup methods
  class_attribute :component_initializers, default: []
  class_attribute :component_setups, default: []

  #
  # Return the current configuration of this component.
  #
  # @return LocoMotion::ComponentConfig
  #
  attr_reader :config

  #
  # Allow users to alter the config through the component itself
  #
  delegate :set_tag_name, :add_css, :add_html, :add_stimulus_controller, :modifiers,
    to: :config

  #
  # Create a new instance of a component.
  #
  def initialize(*args, **kws, &block)
    super

    # Create our config object
    @config = LocoMotion::ComponentConfig.new(self, **kws, &block)

    # Run registered initializer hooks from concerns
    self.class.component_initializers.each { |initializer| send(initializer) }

    # Allow certain components to skip styling if they are being inherited
    @skip_styling = config_option(:skip_styling, false)

    # Allow manual passing of the loco parent on init if it's not auto-set
    # via slots
    @loco_parent = kws[:loco_parent] if kws.key?(:loco_parent)
  end

  #
  # Run registered setup hooks from concerns before rendering.
  #
  def before_render
    # Note: ViewComponent::Base does not define before_render, so no super call needed.
    self.class.component_setups.each { |setup| send(setup) }
  end

  #
  # Override the default slot to render the BasicComponent if no component is
  # provided.
  #
  def self.renders_one(*args)
    # If they don't pass extra options, default to BasicComponent
    args&.size == 1 ?  super(*args + [LocoMotion::BasicComponent]) : super
  end

  #
  # Override the default many slot to render the BasicComponent if no component
  # is provided.
  #
  def self.renders_many(*args)
    # If they don't pass extra options, default to BasicComponent
    args&.size == 1 ?  super(*args + [LocoMotion::BasicComponent]) : super
  end

  #
  # Sets the component name used in CSS generation.
  #
  # @param component_name [Symbol,String] The name of the component.
  #
  def self.set_component_name(component_name)
    self.component_name = component_name
  end

  #
  # Defines a new part of this component which can customize CSS, HTML and more.
  #
  # @param part_name [Symbol] The name of the part.
  # @param part_defaults [Hash] Any default config options such as `tag_name`.
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
  # Convenience method for defining multiple parts at once with no defaults.
  #
  # @param part_names [Array<Symbol>] The names of the parts you wish to define.
  #
  def self.define_parts(*part_names)
    (part_names || []).each do |part_name|
      define_part(part_name)
    end
  end

  #
  # Register an instance method to be called during component initialization.
  #
  # @param method_name [Symbol] The name of the instance method to call.
  #
  def self.register_component_initializer(method_name)
    # Ensure we don't modify the parent class's array directly
    self.component_initializers += [method_name.to_sym]
  end

  #
  # Register an instance method to be called before component rendering.
  #
  # @param method_name [Symbol] The name of the instance method to call.
  #
  def self.register_component_setup(method_name)
    # Ensure we don't modify the parent class's array directly
    self.component_setups += [method_name.to_sym]
  end

  #
  # Defines a single modifier of this component. Modifiers control certain
  # rendering aspects of the component.
  #
  # @param modifier_name [Symbol] The name of the modifier.
  #
  def self.define_modifier(modifier_name)
    define_modifiers(modifier_name)
  end

  #
  # Define multiple modifiers for this component. Modifiers control certain
  # rendering aspects of the component.
  #
  # @param modifier_names [Array[Symbol]] An array of the modifier names you wish
  #   to define.
  #
  def self.define_modifiers(*modifier_names)
    # Note that since we're using Rails' class_attribute method for these, we
    # must take care not to alter the original object but rather use a setter
    # (the `+=` in this case) to set the new value so Rails knows not to
    # override the parent value.
    #
    # For example, we cannot use `<<` or `concat` here.
    self.valid_modifiers ||= []
    self.valid_modifiers += modifier_names
  end

  #
  # Define a single size of this component. Sizes control how big or small this
  # component will render.
  #
  # @param size_name [Symbol] The name of the size you wish to define.
  #
  def self.define_size(size_name)
    define_sizes(size_name)
  end

  #
  # Define multiple sizes for this component. Sizes control how big or small
  # this component will render.
  #
  # @param size_names [Array[Symbol]] An array of the sizes you wish to define.
  #
  def self.define_sizes(*size_names)
    # Note that since we're using Rails' class_attribute method for these, we
    # must take care not to alter the original object but rather use a setter
    # (the `+=` in this case) to set the new value so Rails knows not to
    # override the parent value.
    #
    # For example, we cannot use `<<` or `concat` here.
    self.valid_sizes ||= []
    self.valid_sizes += size_names
  end

  #
  # Allows you to bulid a customized version of this component without having to
  # define a new class.
  #
  def self.build(*build_args, **build_kws, &build_block)
    klass = Class.new(self)

    # Unless already defined, delegate the name method to the superclass so
    # ViewComponent can find the sidecar partials and render them when no call
    # method is defined.
    unless klass.method_defined?(:name)
      klass.instance_eval do
        def name
          superclass.name
        end
      end
    end

    # Override the initialize method to combine the build and instance args
    klass.class_eval do
      original_initialize = method_defined?(:initialize) ? instance_method(:initialize) : nil

      define_method(:initialize) do |*instance_args, **instance_kws, &instance_block|
        if original_initialize
          original_initialize.bind(self).call
        else
          super(*instance_args, **instance_kws, &instance_block)
        end

        @config.smart_merge!(**build_kws)
      end
    end

    # Finally, execute any block they passed in to allow for customizations
    klass.class_eval(&build_block) if block_given?

    klass
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


  #
  # Sets the parent component of this component. Enables child components to ask
  # questions of their parent and access parent config.
  #
  def set_loco_parent(parent)
    @loco_parent = parent
  end
  attr_reader :loco_parent

  #
  # Renders the given part.
  #
  def part(part_name, &block)

    # Validate the part_name
    @config.validate_part(part_name)

    # Grab the rendered tag name
    tag_name = rendered_tag_name(part_name)

    if block_given?
      content_tag(tag_name, **rendered_html(part_name), &block)
    else
      # The `tag()` helper will allow you to pass any tag without a block, but
      # this isn't valid HTML. In particular, it will render a "self-closing"
      # <div /> tag which doesn't actually close the div.
      #
      # Therefore, we need to pass some kind of block to ensure it closes. We've
      # choosen a comment to keep the output as clean as possible while still
      # informing a developer what is happening.
      if SELF_CLOSING_TAGS.include?(tag_name.to_sym)
        tag(tag_name, **rendered_html(part_name))
      else
        content_tag(tag_name, **rendered_html(part_name)) do
          empty_part_content(tag_name)
        end
      end
    end
  end

  def empty_part_content(tag_name)
    unless EMPTY_PART_IGNORED_TAGS.include?(tag_name.to_sym)
      "<!-- Empty Part Block //-->".html_safe
    end
  end

  #
  # Returns the user-provided or component-default HTML tag-name.
  #
  # @param part_name [Symbol] The part whose tag-name you desire.
  #
  # @return [Symbol,String] The HTML tag-name for the requested comopnent part.
  #
  def rendered_tag_name(part_name)
    part = @config.get_part(part_name)

    part[:user_tag_name] || part[:default_tag_name]
  end

  #
  # Builds a string suitable for the HTML element's `class` attribute for the
  # requested component part.
  #
  # @param part_name [Symbol] The component part whose CSS you desire.
  #
  # @return [String] A string of CSS names.
  #
  def rendered_css(part_name)
    default_css = @config.get_part(part_name)[:default_css]
    user_css = @config.get_part(part_name)[:user_css]

    cssify([default_css, user_css])
  end

  #
  # Builds a Hash of all of the HTML attributes for the requested component
  # part.
  #
  # @param part_name [Symbol] The component part whose HTML you desire.
  #
  # @return [Hash] A combination of all generated, component default, and
  #   user-specified HTML attributes for the part.
  #
  def rendered_html(part_name)
    default_html = @config.get_part(part_name)[:default_html] || {}
    user_html = @config.get_part(part_name)[:user_html] || {}

    generated_html = {
      class: rendered_css(part_name),
      data: rendered_data(part_name)
    }.deep_merge(default_html).deep_merge(user_html)
  end

  #
  # Builds the HTML `data` attribute.
  #
  # @param part_name [Symbol] The component part whose HTML `data` attribute
  #   you desire.
  #
  # @return [Hash] A hash of objects to be rendered in the `data` attribute.
  #
  def rendered_data(part_name)
    generated_data = {}

    stimulus_controllers = rendered_stimulus_controllers(part_name)

    generated_data[:controller] = stimulus_controllers if stimulus_controllers.present?

    generated_data
  end

  #
  # Builds a list of Stimulus controllers for the HTML `data-controller`
  # attribute.
  #
  # @param part_name [Symbol] The component part whose Stimulus controllers you
  #   desire.
  #
  # @ return [String] A space-separated list of Stimulus controllers.
  #
  def rendered_stimulus_controllers(part_name)
    default_controllers = @config.get_part(part_name)[:default_stimulus_controllers]
    user_controllers = @config.get_part(part_name)[:user_stimulus_controllers]

    strip_spaces([default_controllers, user_controllers].join(" "))
  end

  #
  # Convert strings, symbols, and arrays of those into a single CSS-like string.
  #
  def cssify(content)
    css = [content].flatten.compact

    strip_spaces(css.join(" "))
  end

  #
  # Strip extra whitespace from a given string.
  #
  # @param str [String] The string you wish to strip.
  #
  # @return [String] A string with minimal possible whitespace.
  #
  def strip_spaces(str)
    str.gsub(/ +/, " ").strip
  end

  #
  # Retrieve the requested component option, or the desired default if no option
  # was provided.
  #
  # @param key [Symbol] The name of the keyword argument option you wish to
  #   retrieve.
  # @param default [Object] Any value that you wish to use as a default should
  #   the option be undefined. Defaults to `nil`.
  #
  def config_option(key, default = nil)
    value = @config.options[key]

    value.nil? ? default : value
  end

  # Provide some nice output for debugging or other purposes.
  #
  def inspect
    parts = component_parts.map do |part_name, part_defaults|
      {
        part_name: part_name,
        tag_name: rendered_tag_name(part_name),
        css: rendered_css(part_name),
        html: rendered_html(part_name)
      }
    end

    [
      "#<#{self.class.name}",
      "@component_name=#{(component_name || :unnamed).inspect}",
      "@valid_modifiers=#{valid_modifiers.inspect}",
      "@valid_sizes=#{valid_sizes.inspect}",
      "@config=#{@config.inspect}",
      "@component_parts=#{parts.inspect}",
      "@loco_parent=#{loco_parent.inspect}",
    ].join(" ") + ">"
  end
end
