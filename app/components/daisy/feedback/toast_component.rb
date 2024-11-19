class Daisy::Feedback::ToastComponent < LocoMotion::BaseComponent
  def before_render
    add_css(:component, "toast")
  end

  def call
    part(:component) { content }
  end
end
