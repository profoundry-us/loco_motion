class Daisy::Feedback::ToastComponent < LocoMotion.configuration.base_component_class
  def before_render
    add_css(:component, "toast")
  end

  def call
    part(:component) { content }
  end
end
