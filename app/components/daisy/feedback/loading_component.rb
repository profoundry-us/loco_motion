class Daisy::Feedback::LoadingComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  def before_render
    add_css(:component, "loading")
  end

  def call
    part(:component)
  end
end
