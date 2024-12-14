class Daisy::Mockup::BrowserComponent < LocoMotion::BaseComponent

  renders_one :toolbar, LocoMotion::BasicComponent.build(css: "mockup-browser-toolbar")

  def before_render
    add_css(:component, "mockup-browser")
  end

  def call
    part(:component) do
      concat(toolbar) if toolbar
      concat(content)
    end
  end

end
