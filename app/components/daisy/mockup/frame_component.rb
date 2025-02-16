class Daisy::Mockup::FrameComponent < LocoMotion::BaseComponent
  def before_render
    add_css(:component, "mockup-window")
  end

  def call
    part(:component) do
      content
    end
  end
end
