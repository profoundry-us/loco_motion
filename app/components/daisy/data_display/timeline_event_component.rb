#
# A component for rendering individual events within a timeline. Each event can
# have three sections: start (typically a date or time), middle (an icon or
# marker), and end (the event description).
#
# @part start The container for the start content (e.g., date/time).
# @part middle The container for the middle content.
# @part middle_icon Container for a simple icon when not using custom middle
#   content.
# @part end The container for the end content (e.g., description).
# @part separator The line connecting this event to the next one.
#
# @slot start Custom content for the start section. You can also provide
#   simple text via the start option.
#
# @slot middle Custom content for the middle section. You can also provide
#   simple text via the middle option, or an icon via the middle_icon option.
#
# @slot end Custom content for the end section. You can also provide simple
#   text via the end option.
#
# @note The middle and middle_icon options are mutually exclusive. If both are
#   provided, middle takes precedence.
#
class Daisy::DataDisplay::TimelineEventComponent < LocoMotion::BaseComponent
  renders_one :start, LocoMotion::BasicComponent.build(css: "timeline-start")
  renders_one :middle, LocoMotion::BasicComponent.build(css: "timeline-middle")
  renders_one :end, LocoMotion::BasicComponent.build(css: "timeline-end")

  define_parts :start, :middle, :middle_icon, :end, :separator

  #
  # Creates a new timeline event component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws [String] :start Text to display in the start section. You can
  #   also provide custom content using the start slot.
  #
  # @option kws [String] :middle Text to display in the middle section. You
  #   can also provide custom content using the middle slot.
  #
  # @option kws [String] :middle_icon Name of a heroicon to display in the
  #   middle section. Ignored if middle is provided.
  #
  # @option kws [String] :end Text to display in the end section. You can
  #   also provide custom content using the end slot.
  #
  def initialize(*args, **kws, &block)
    super(*args, **kws, &block)

    @event_index = nil
    @events_length = nil

    @simple_start = config_option(:start)
    @simple_middle = config_option(:middle)
    @simple_middle_icon = config_option(:middle_icon)
    @simple_end = config_option(:end)
  end

  def before_render
    set_tag_name(:component, :li)

    setup_parts
    setup_separator
  end

  def setup_parts
    add_css(:start, "timeline-start")
    add_css(:middle, "timeline-middle")
    add_css(:end, "timeline-end")
  end

  def setup_separator
    set_tag_name(:separator, :hr)
  end

  def set_event_index(index)
    @event_index = index
  end

  def set_events_length(length)
    @events_length = length
  end
end
