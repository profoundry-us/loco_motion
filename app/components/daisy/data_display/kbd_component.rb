# This is the Kbd (Keyboard) component.
class Daisy::DataDisplay::KbdComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  set_component_name :kbd

  # Create a new kbd component.
  def initialize(*args, **kws, &block)
    super

    set_tag_name(:component, :span)
  end

  def before_render
    setup_component
  end

  #
  # Renders the kbd (Keyboard) component.
  #
  # Because this is an inline component which might be utlized alongside text,
  # we utilize the `call` method instead of a template to ensure that no
  # additional whitespace gets added to the output.
  #
  def call
    part(:component) { content }
  end

  private

  def setup_component
    add_css(:component, "kbd")
  end
end
