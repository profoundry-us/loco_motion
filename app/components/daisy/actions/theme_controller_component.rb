# Renders a very basic radio-button theme controller.
class Daisy::Actions::ThemeControllerComponent < LocoMotion::BaseComponent
  SOME_THEMES = ["light", "dark", "synthwave", "retro", "cyberpunk", "wireframe"].freeze

  def before_render
    add_css(:component, "flex flex-col lg:flex-row gap-4 items-center")
  end
end
