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
# @loco_example With Icons
#   = daisy_badge(title: "New", left_icon: "sparkles")
#   = daisy_badge(title: "Download", right_icon: "arrow-down")
#   = daisy_badge(title: "Star", left_icon: "star", right_icon: "plus")
#
# @loco_example With Links
#   = daisy_badge(title: "Documentation", href: "#", css: "badge-primary")
#   = daisy_badge(title: "External", href: "#", target: "_blank", css: "badge-secondary")
#   = daisy_badge(title: "GitHub", href: "#", left_icon: "code-bracket")
#
# @loco_example Using a Block
#   = daisy_badge do
#     %span.flex.items-center.gap-1
#       = heroicon "star", css: "size-4"
#       Featured
#
# @loco_example Default Badge
#   = daisy_badge { "Default Badge" }
#
# @loco_example Primary Badge
#   = daisy_badge(css: "badge-primary") { "Primary Badge" }
#
# @loco_example Secondary Badge
#   = daisy_badge(css: "badge-secondary") { "Secondary Badge" }
#
# @loco_example Accent Badge
#   = daisy_badge(css: "badge-accent") { "Accent Badge" }
#
# @loco_example Ghost Badge
#   = daisy_badge(css: "badge-ghost") { "Ghost Badge" }
#
# @loco_example Info Badge
#   = daisy_badge(css: "badge-info") { "Info Badge" }
#
# @loco_example Success Badge
#   = daisy_badge(css: "badge-success") { "Success Badge" }
#
# @loco_example Warning Badge
#   = daisy_badge(css: "badge-warning") { "Warning Badge" }
#
# @loco_example Error Badge
#   = daisy_badge(css: "badge-error") { "Error Badge" }
#
# @loco_example Outline Primary Badge
#   = daisy_badge(css: "badge-primary badge-outline") { "Outline Primary" }
#
# @loco_example Outline Success Badge
#   = daisy_badge(css: "badge-success badge-outline") { "Outline Success" }
#
# @loco_example Outline Warning Badge
#   = daisy_badge(css: "badge-warning badge-outline") { "Outline Warning" }
#
# @loco_example Outline Error Badge
#   = daisy_badge(css: "badge-error badge-outline") { "Outline Error" }
#
# @loco_example Soft Primary Badge
#   = daisy_badge(css: "badge-primary badge-soft") { "Soft Primary" }
#
# @loco_example Soft Success Badge
#   = daisy_badge(css: "badge-success badge-soft") { "Soft Success" }
#
# @loco_example Soft Warning Badge
#   = daisy_badge(css: "badge-warning badge-soft") { "Soft Warning" }
#
# @loco_example Soft Error Badge
#   = daisy_badge(css: "badge-error badge-soft") { "Soft Error" }
#
# @loco_example Dash Primary Badge
#   = daisy_badge(css: "badge-primary badge-dash") { "Dash Primary" }
#
# @loco_example Dash Success Badge
#   = daisy_badge(css: "badge-success badge-dash") { "Dash Success" }
#
# @loco_example Dash Warning Badge
#   = daisy_badge(css: "badge-warning badge-dash") { "Dash Warning" }
#
# @loco_example Dash Error Badge
#   = daisy_badge(css: "badge-error badge-dash") { "Dash Error" }
#
# @loco_example Badge with Icon
#   = daisy_badge(icon: "check") { "Icon Badge" }
#
# @!parse class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::IconableComponent
  include LocoMotion::Concerns::LinkableComponent
  include LocoMotion::Concerns::TippableComponent

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
  # @option kwargs href [String] A path or URL to which the user will be
  #   directed when the badge is clicked. Forces the Badge to use an `<a>` tag.
  #
  # @option kwargs target [String] The HTML `target` of for the `<a>` tag
  #   (`_blank`, `_parent`, or a specific tab / window / iframe, etc).
  #
  # @option kwargs icon [String] The name of Hero icon to render inside the
  #   badge. This is an alias of `left_icon`.
  #
  # @option kwargs icon_css [String] The CSS classes to apply to the icon.
  #   This is an alias of `left_icon_css`.
  #
  # @option kwargs icon_html [Hash] Additional HTML attributes to apply to the
  #   icon. This is an alias of `left_icon_html`.
  #
  # @option kwargs left_icon [String] The name of Hero icon to render inside
  #   the badge to the left of the text.
  #
  # @option kwargs left_icon_css [String] The CSS classes to apply to the left
  #   icon.
  #
  # @option kwargs left_icon_html [Hash] Additional HTML attributes to apply to
  #   the left icon.
  #
  # @option kwargs right_icon [String] The name of Hero icon to render inside
  #   the badge to the right of the text.
  #
  # @option kwargs right_icon_css [String] The CSS classes to apply to the
  #   right icon.
  #
  # @option kwargs right_icon_html [Hash] Additional HTML attributes to apply
  #   to the right icon.
  #
  def initialize(title = nil, **kws, &block)
    super

    @simple_title = config_option(:title, title)
  end

  def before_render
    # Run component setup *before* super to allow LinkableComponent to override tag
    setup_component

    super
  end

  #
  # Renders the badge component.
  #
  # Because this is an inline component which might be utlized alongside text,
  # we utilize the `call` method instead of a template to ensure that no
  # additional whitespace gets added to the output.
  #
  def call
    part(:component) do
      concat(render_left_icon)
      concat(content || @simple_title)
      concat(render_right_icon)
    end
  end

  private

  def setup_component
    set_tag_name(:component, :span)
    add_css(:component, "badge")
  end
end
