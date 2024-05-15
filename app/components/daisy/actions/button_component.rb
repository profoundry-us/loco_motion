# Here are the Button docs!
class Daisy::Actions::ButtonComponent < LocoMotion.configuration.base_component_class
  set_component_name :btn

  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title, "Submit")
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    set_tag_name(:component, :button)
    add_css(:component, 'btn')
  end
end
