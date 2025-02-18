#
# The Badge component renders as a small, rounded element used to display status,
# labels, or notifications. It supports various background colors and can be used
# inline with text.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @loco_example Basic Usage
#   = daisy_badge("New!")
#
# @loco_example With Different Colors
#   = daisy_badge("Primary", css: "badge-primary")
#   = daisy_badge("Secondary", css: "badge-secondary")
#   = daisy_badge("Accent", css: "badge-accent")
#   = daisy_badge("Ghost", css: "badge-ghost")
#
# @loco_example With Tooltip
#   = daisy_badge("Beta", tip: "This feature is in beta testing")
#
# @loco_example Using a Block
#   = daisy_badge do
#     %span.flex.items-center.gap-1
#       = heroicon_tag "star", css: "size-4"
#       Featured
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
  def initialize(title = nil, **kws, &block)
    super

    @title = config_option(:title, title)
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
