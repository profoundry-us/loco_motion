class Daisy::Layout::ArtboardComponent < LocoMotion.configuration.base_component_class

  def before_render
    add_css(:component, "artboard")
  end

  def call
    part(:component) { content }
  end

end
