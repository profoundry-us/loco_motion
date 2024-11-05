class Daisy::Feedback::SkeletonComponent < LocoMotion.configuration.base_component_class
  def before_render
    add_css(:component, "skeleton")
  end

  def call
    part(:component) { content }
  end
end
