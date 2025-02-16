#
# The Badge component renders as a small, rounded element with various
# background colors.
#
# @loco_example Basic Usage
#   = daisy_badge("New!")
#   = daisy_badge(title: "New!")
#   = daisy_badge { "New!" }
#
# @!parse class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  set_component_name :badge

  #
  # Create a new Badge component.
  #
  # @param title [String] The text to display in the badge. You can also pass
  #   the title as a keyword argument or provide content via a block.
  #
  # @param kwargs [Hash] The keyword arguments for the component.
  #
  # @option kwargs title [String] The text to display in the badge. You can also
  #   pass the title as the first argument or provide content via a block.
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
    part(:component) { content || @title }
  end

  private

  def setup_component
    set_tag_name(:component, :span)
    add_css(:component, "badge")
  end
end
