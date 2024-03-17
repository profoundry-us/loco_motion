class LocoMotion::ComponentConfig
  attr_reader :component, :parts, :options, :variants, :size

  def initialize(component, **kws, &block)
    @component = component
    @options = kws

    @parts = {}
    @variants = (kws[:variants] || [kws[:variant]]).compact
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
    @parts[:component][:user_tag_name] = @options[:tag_name] if @options[:tag_name]
    @parts[:component][:user_css].push(@options[:css]) if @options[:css]
    @parts[:component][:user_html].deep_merge!(@options[:html]) if @options[:html]
    @parts[:component][:user_stimulus_controllers].push(@options[:controllers]) if @options[:controllers]
  end

  def get_part(part_name)
    @parts[part_name] || {}
  end

  #
  # Sets the default tag name for the requested component part.
  #
  def set_tag_name(part_name, tag_name)
    @parts[part_name][:default_tag_name] = tag_name
  end

  #
  # Adds default CSS to the requested component part.
  #
  def add_css(part_name, css)
    @parts[part_name][:default_css] << css
  end

  #
  # Adds default HTML to the requested component part.
  #
  def add_html(part_name, html)
    @parts[part_name][:default_html] = @parts[part_name][:default_html].merge(html)
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
    # Check to make sure they have passed a valid / defined variant
    (@variants || []).each do |variant|
      if variant.present? && !@component.valid_variants.include?(variant)
        raise LocoMotion::InvalidVariantError.new(variant, @component)
      end
    end
  end

  #
  # Render a Hash version of the config.
  #
  def to_h
    {
      options: @options,
      parts: @parts,
      variants: @variants,
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
      "@variants=#{@variants.inspect}",
      "@size=#{@size.inspect}",
    ].join(" ") + ">"
  end
end
