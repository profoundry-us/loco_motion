class LocoMotion::ComponentConfig
  attr_reader :component, :parts, :options, :modifiers, :size

  def initialize(component, **kws, &block)
    @component = component
    @options = kws

    @parts = {}
    @modifiers = (kws[:modifiers] || [kws[:modifier]]).compact
    @size = kws[:size]

    build
    validate
  end

  def build
    # Allow users to pass css/html for a specific part (i.e. modal_dialog)
    @component.component_parts.each do |part, defaults|
      @parts[part] = {
        default_css: [],
        default_html: {},
        default_tag_name: defaults[:tag_name] || :div,
        default_stimulus_controllers: [],

        user_css: @options["#{part}_css".to_sym] || [],
        user_html: @options["#{part}_html".to_sym] || {},
        user_tag_name: @options["#{part}_tag_name".to_sym],
        user_stimulus_controllers: @options["#{part}_controllers".to_sym] || [],
      }
    end

    # Allow useres to pass some shortened attributes for the component part
    merge_user_options!(**@options)
  end

  #
  # Add specific component user options if they pass shortened attributes.
  #
  def merge_user_options!(**kws)
    @parts[:component][:user_tag_name] = kws[:tag_name] if kws[:tag_name]
    @parts[:component][:user_css].push(kws[:css]) if kws[:css]
    @parts[:component][:user_html].deep_merge!(kws[:html]) if kws[:html]
    @parts[:component][:user_stimulus_controllers].push(kws[:controllers]) if kws[:controllers]
  end

  #
  # Merge additional options into the defaults config by combining the new
  # options with the existing options, rather than overwriting (where possible).
  #
  # HTML will be deep merged, CSS will be appended, and tag_name will be
  # overwritten.
  #
  def smart_merge!(**kws)
    @component.component_parts.each do |part, defaults|
      set_tag_name(part, kws["#{part}_tag_name".to_sym])
      add_css(part, kws["#{part}_css".to_sym])
      add_html(part, kws["#{part}_html".to_sym])

      controllers = kws["#{part}_controllers".to_sym] || []

      controllers.each do |controller_name|
        add_stimulus_controller(part, controller_name)
      end
    end

    # Make sure to merge any user-provided options as well
    merge_user_options!(**kws)
  end

  #
  # Returns the part for the reqeust part name or an empty hash if none was
  # found.
  #
  def get_part(part_name)
    @parts[part_name] || {}
  end

  #
  # Sets the default tag name for the requested component part.
  #
  def set_tag_name(part_name, tag_name)
    @parts[part_name][:default_tag_name] = tag_name if tag_name
  end

  #
  # Adds default CSS to the requested component part.
  #
  def add_css(part_name, css)
    @parts[part_name][:default_css] << css if css
  end

  #
  # Adds default HTML to the requested component part.
  #
  def add_html(part_name, html)
    @parts[part_name][:default_html] = @parts[part_name][:default_html].deep_merge(html) if html
  end

  #
  # Add a default Stimulus (Javascript) controller to the requested component part.
  #
  def add_stimulus_controller(part_name, controller_name)
    @parts[part_name] ||= {}
    @parts[part_name][:default_stimulus_controllers] ||= []
    @parts[part_name][:default_stimulus_controllers] << controller_name
  end

  #
  # Validate the component config and throw errors if there are issues.
  #
  def validate
    validate_modifiers
  end

  #
  # Validate that all of the modifiers are correct.
  #
  def validate_modifiers
    # Check to make sure they have passed a valid / defined modifier
    (@modifiers || []).each do |modifier|
      if modifier.present? && !@component.valid_modifiers.include?(modifier)
        raise LocoMotion::InvalidModifierError.new(modifier, @component)
      end
    end
  end

  #
  # Validates that the requested part is valid for the component.
  #
  def validate_part(part_name)
    raise LocoMotion::UnknownPartError.new(part_name, @component) unless valid_parts.include?(part_name)
  end

  #
  # Return a list of valid parts for the component.
  #
  def valid_parts
    @parts.keys
  end

  #
  # Render a Hash version of the config.
  #
  def to_h
    {
      options: @options,
      parts: @parts,
      modifiers: @modifiers,
      size: @size
    }
  end

  #
  # For now, just return the Hash version for inspect.
  #
  def inspect
    [
      "#<#{self.class.name}",
      "@options=#{@options.inspect}",
      "@parts=#{@parts.inspect}",
      "@modifiers=#{@modifiers.inspect}",
      "@size=#{@size.inspect}",
    ].join(" ") + ">"
  end
end
