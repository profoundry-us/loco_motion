class Daisy::DataDisplay::TimelineComponent < LocoMotion.configuration.base_component_class
  class TimelineEvent < LocoMotion::BasicComponent
    renders_one :start, LocoMotion::BasicComponent.build(css: "timeline-start")
    renders_one :middle, LocoMotion::BasicComponent.build(css: "timeline-middle")
    renders_one :middle_icon, Daisy::BasicComponent.build(css: "timeline-middle")
    renders_one :end, LocoMotion::BasicComponent.build(css: "timeline-event-message")
  end

  renders_many :events, TimelineEvent
end
