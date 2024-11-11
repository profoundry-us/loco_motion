class Daisy::Feedback::SkeletonComponent < LocoMotion::BaseComponent
  def before_render
    add_css(:component, "skeleton")
  end

  def call
    part(:component) { content }
  end
end
