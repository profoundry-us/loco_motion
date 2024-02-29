class LocoMotion::ComponentConfig
  attr_accessor :parts
  attr_accessor :stimulus_controllers
  attr_accessor :variant

  attr_accessor :component, :options

  def initialize(component, **kws, &block)
    @component = component
    @options = kws

    @parts = kws[:parts] || {}
    @stimulus_controllers = kws[:stimulus_controllers] || {}
    @variant = kws[:variant]

    build
    validate
  end

  def build
    # Allow users to pass css/html for a specific part (i.e. modal_dialog)
    @component.component_parts.each do |part, defaults|
      @parts[part] = {
        component_css: [],
        component_html: {},
        tag_name: @options["#{part}_tag_name".to_sym] || defaults[:tag_name] || :div,
        user_css: @options["#{part}_css".to_sym] || [],
        user_html: @options["#{part}_html".to_sym] || {},
        stimulus_controllers: @options["#{part}_controllers".to_sym] || [],
      }
    end

    # Allow useres to pass some shortened attributes for the component part
    @parts[:component][:tag_name] = @options[:tag_name] if @options[:tag_name]
    @parts[:component][:user_css].push(@options[:css]) if @options[:css]
    @parts[:component][:user_html].deep_merge!(@options[:html]) if @options[:html]
    @parts[:component][:stimulus_controllers].push(@options[:controllers]) if @options[:controllers]
  end

  def validate
    # Check to make sure they have passed a valid / defined variant
    if @variant.present? && !@component.variants.include?(@variant)
      raise "Unknown variant `#{@config.variant.inspect}`. Valid variants are #{variants.to_sentence}."
    end
  end
end
