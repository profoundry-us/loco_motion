#
# The Countdown component displays a timer that counts down to or up from a
# specific duration. It can show days, hours, minutes, and seconds with
# customizable separators and formats.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @part days The container for the days value.
# @part hours The container for the hours value.
# @part minutes The container for the minutes value.
# @part seconds The container for the seconds value.
#
# @loco_example Basic Usage
#   = daisy_countdown(1.day + 2.hours + 30.minutes)
#
# @loco_example With Word Separators
#   = daisy_countdown(5.days + 12.hours + 45.minutes, modifier: :words) do |cd|
#     1 day 12 hours 45 minutes remaining
#
# @loco_example With Letter Separators
#   = daisy_countdown(24.hours + 59.minutes + 59.seconds, modifier: :letters) do |cd|
#     24h 59m 59s left
#
# @loco_example With Custom Separator
#   = daisy_countdown(3.hours + 30.minutes, separator: " → ")
#
class Daisy::DataDisplay::CountdownComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  define_parts :days, :hours, :minutes, :seconds
  define_modifiers :words, :letters

  #
  # Creates a new countdown component.
  #
  # @param duration [ActiveSupport::Duration] The duration to count down from.
  #   Can be created using Rails duration helpers like 1.day, 2.hours, etc.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws [ActiveSupport::Duration] :duration The duration to count down
  #   from. Alternative to providing it as the first argument.
  #
  # @option kws [Symbol] :modifier Optional display modifier. Use :words for
  #   "days", "hours", etc., or :letters for "d", "h", etc.
  #
  # @option kws [String] :separator The separator to use between time parts.
  #   Defaults to ":". Ignored when using :words or :letters modifiers.
  #
  # @option kws [String] :parts_css CSS classes to apply to all time parts
  #   (days, hours, minutes, seconds).
  #
  # @option kws [Hash] :parts_html HTML attributes to apply to all time parts.
  #
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
    add_css(:component, "where:gap-x-2") if modifiers.include?(:words)

    %i(days hours minutes seconds).each do |part|
      default_html = {
        data: {
          # Note: We can't use nested hashes here because the Rails content_tag
          # helper is stupid and won't traverse them.
          "countdown-target": part
        }
      }

      add_css(part, "countdown")
      add_css(part, "where:gap-x-1") if modifiers.include?(:words)
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
