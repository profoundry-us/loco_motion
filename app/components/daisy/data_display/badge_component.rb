#
# The Badge component renders as a small, rounded element with various
# background colors.
#
# @!parse class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  set_component_name :badge

  #
  # Create a new Badge component.
  #
  def initialize(*args, **kws, &block)
    super

    @title = config_option(:title, args[0])
  end

  def before_render
    setup_component
  end

  #
  # Renders the badge component.
  #
  # Because this is an inline component which might be utlized alongside text,
  # we utilize the `call` method instead of a template to ensure that no
  # additional whitespace gets added to the output.
  #
  def call
    part(:component) { @title || content }
  end

  private

  def setup_component
    set_tag_name(:component, :span)
    add_css(:component, "badge")
  end
end
