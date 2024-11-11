class Daisy::Feedback::RadialProgressComponent < LocoMotion::BaseComponent

  def initialize(*args, **kws, &block)
    super

    @value = config_option(:value)
    @size = config_option(:size)
    @thickness = config_option(:thickness)
  end

  def before_render
    add_css(:component, "radial-progress")

    styles = []

    styles << "--value: #{@value}" if @value != nil
    styles << "--size: #{@size}" if @size != nil
    styles << "--thickness: #{@thickness}" if @thickness != nil

    add_html(:component, { role: "progressbar" })
    add_html(:component, { style: styles.join(";") }) if styles.present?
  end

  def call
    part(:component) { content }
  end

end

