class Daisy::Layout::StackComponent < LocoMotion::BaseComponent
  def before_render
    add_css(:component, "stack")
  end

  def call
    part(:component) { content }
  end
end
