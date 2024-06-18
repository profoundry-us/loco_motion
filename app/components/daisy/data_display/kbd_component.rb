# This is the Kbd (Keyboard) component.
class Daisy::DataDisplay::KbdComponent < LocoMotion.configuration.base_component_class
  set_component_name :kbd

  # Create a new kbd component.
  def initialize(*args, **kws, &block)
    super

    set_tag_name(:component, :span)
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    add_css(:component, "kbd")
  end
end
