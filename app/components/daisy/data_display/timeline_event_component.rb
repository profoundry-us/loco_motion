class Daisy::DataDisplay::TimelineEventComponent < LocoMotion.configuration.base_component_class
  renders_one :start, LocoMotion::BasicComponent.build(css: "timeline-start")
  renders_one :middle, LocoMotion::BasicComponent.build(css: "timeline-middle")
  renders_one :end, LocoMotion::BasicComponent.build(css: "timeline-end")

  define_parts :start, :middle, :middle_icon, :end, :separator

  #
  # middle and middle_icon are mutually exclusive, middle takes presedence
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
