class Daisy::DataDisplay::CountdownComponent < LocoMotion.configuration.base_component_class

  # renders_one :days, LocoMotion::BasicComponent.build(tag_name: :span)
  # renders_one :hours
  # renders_one :minutes
  # renders_one :seconds

  define_parts :days, :hours, :minutes, :seconds
  define_modifiers :words, :letters

  def initialize(*args, **kws, &block)
    super

    @duration = config_option(:duration, args[0])
    @separator = config_option(:separator, ":")
    @parts_css = config_option(:parts_css)
    @parts_html = config_option(:parts_html)
  end

  def before_render
    add_stimulus_controller(:component, "countdown")

    add_css(:component, "flex")
    add_css(:component, "[:where(&)]:gap-x-2") if modifiers.include?(:words)

    %i(days hours minutes seconds).each do |part|
      default_html = {
        data: {
          # Note: We can't use nested hashes here because the Rails content_tag
          # helper is stupid and won't traverse them.
          "countdown-target": part
        }
      }

      add_css(part, "countdown")
      add_css(part, "[:where(&)]:gap-x-1") if modifiers.include?(:words)
      add_css(part, @parts_css) if @parts_css

      add_html(part, default_html)
      add_html(part, @parts_html) if @parts_html
    end
  end

  def dparts
    @duration&.parts || {}
  end

  def days_separator
    return unless dparts[:days] && dparts[:hours]
    return "days" if modifiers.include?(:words)
    return "d" if modifiers.include?(:letters)
    return @separator
  end

  def hours_separator
    return unless dparts[:hours] && dparts[:minutes]
    return "hours" if modifiers.include?(:words)
    return "h" if modifiers.include?(:letters)
    return @separator
  end

  def minutes_separator
    return unless dparts[:minutes] && dparts[:seconds]
    return "minutes" if modifiers.include?(:words)
    return "m" if modifiers.include?(:letters)
    return @separator
  end

  def seconds_separator
    return unless dparts[:seconds]
    return "seconds" if modifiers.include?(:words)
    return "s" if modifiers.include?(:letters)
    return nil # No default separator for seconds
  end
end
