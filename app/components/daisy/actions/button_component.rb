# Here are the Button docs!
class Daisy::Actions::ButtonComponent < LocoMotion.configuration.base_component_class
  set_component_name :btn

  def initialize(*args, **kws, &block)
    super

    @icon = config_option(:icon)
    @icon_css = config_option(:icon_css, "w-5 h-5")
    @icon_html = config_option(:icon_html, {})

    @left_icon = config_option(:left_icon, @icon)
    @left_icon_css = config_option(:left_icon_css, @icon_css)
    @left_icon_html = config_option(:left_icon_html, @icon_html)

    @right_icon = config_option(:right_icon)
    @right_icon_css = config_option(:right_icon_css, @icon_css)
    @right_icon_html = config_option(:right_icon_html, @icon_html)

    @simple_title = config_option(:title, @left_icon || @right_icon ? nil : "Submit")
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    set_tag_name(:component, :button)
    add_css(:component, "btn")

    add_css(:component, "items-center gap-2") if @icon
  end

  def left_icon_html
    { class: @left_icon_css }.merge(@left_icon_html)
  end

  def right_icon_html
    { class: @right_icon_css }.merge(@right_icon_html)
  end
end
