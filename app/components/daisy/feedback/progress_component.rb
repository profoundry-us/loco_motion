class Daisy::Feedback::ProgressComponent < LocoMotion::BaseComponent

  def initialize(*args, **kws, &block)
    super

    @value = config_option(:value, nil)
    @max = config_option(:max, 100)
  end

  def before_render
    set_tag_name(:component, :progress)
    add_css(:component, "progress")
    add_html(:component, { value: @value, max: @max }) if @value != nil
  end

  def call
    part(:component)
  end

end
