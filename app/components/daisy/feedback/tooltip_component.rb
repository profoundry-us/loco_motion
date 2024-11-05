class Daisy::Feedback::TooltipComponent < LocoMotion.configuration.base_component_class
  def initialize(*args, **kws, &block)
    super

    @tip = config_option(:tip, nil)
  end

  def before_render
    add_css(:component, "tooltip")
    add_html(:component, { data: { tip: @tip } }) if @tip
  end

  def call
    part(:component) { content }
  end
end
