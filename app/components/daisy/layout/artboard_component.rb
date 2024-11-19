class Daisy::Layout::ArtboardComponent < LocoMotion::BaseComponent

  def before_render
    add_css(:component, "artboard")
  end

  def call
    part(:component) { content }
  end

end
