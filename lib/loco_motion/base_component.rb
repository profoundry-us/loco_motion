class LocoMotion::BaseComponent < ViewComponent::Base

  class_attribute :component_name
  class_attribute :component_parts, default: { component: {} }
  class_attribute :valid_variants, default: []
  class_attribute :valid_sizes, default: []

  #
  # Return the current configruation of this component.
  #
  # @return LocoMotion::ComponentConfig
  #
  attr_reader :config

  #
  # Allow users to alter the config through the component itself
  #
  delegate :set_tag_name, :add_css, :add_html, :add_stimulus_controller,
    to: :config

  #
  # Create a new instance of a component.
  #
  def initialize(*args, **kws, &block)
    super

    # Create our config object
    @config = LocoMotion::ComponentConfig.new(self, **kws, &block)
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
    self.valid_variants ||= []
    self.valid_variants += variant_names
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
  # Returns a reference to this component. Useful for passing a parent component
  # into child components.
  #
  # @return [BaseComponent] A reference to this component.
  #
  def component_ref
    self
  end

  #
  # Renders the given part.
  #
  def part(part_name, &block)
    tag_name = rendered_tag_name(part_name)

    content_tag(tag_name, **rendered_html(part_name), &block)
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

    base_css = self.component_name
    variant_css = []
    size_css = nil

    # If we have a base component name, we can generate some variant / size CSS
    if part_name == :component && base_css.present?
      variant_css = (@config.variants || []).map { |variant| "#{base_css}-#{variant}" }
      size_css = "#{base_css}-#{@size}" if @config.size
    end

    cssify([default_css, base_css, variant_css, size_css, user_css])
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
  # Provide some nice output for debugging or other purposes.
  #
  def inspect
    {
      component_name: component_name || :unnamed,
      valid_variants: valid_variants,
      valid_sizes: valid_sizes,
      config: @config.inspect,
      parts: component_parts.map do |part_name, part_defaults|
        {
          part_name: part_name,
          tag_name: rendered_tag_name(part_name),
          css: rendered_css(part_name),
          html: rendered_html(part_name)
        }
      end
    }
  end
end
