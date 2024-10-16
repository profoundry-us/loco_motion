class Daisy::Navigation::NavbarComponent < LocoMotion.configuration.base_component_class
  renders_one :start, LocoMotion::BasicComponent.build(css: "navbar-start")

  renders_one :center, LocoMotion::BasicComponent.build(css: "navbar-center")

  # End is a reserved word in Ruby
  renders_one :tail, LocoMotion::BasicComponent.build(css: "navbar-end")

  def before_render
    add_css(:component, "navbar")
  end
end
