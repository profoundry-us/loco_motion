class Daisy::DataDisplay::TimelineComponent < LocoMotion.configuration.base_component_class
  renders_many :events, Daisy::DataDisplay::TimelineEventComponent

  def before_render
    set_tag_name(:component, :ul)
    add_css(:component, "timeline")
  end
end
