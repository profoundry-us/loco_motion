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
#       = heroicon_tag "star", css: "size-4"
#       Featured
#
# @!parse class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::BadgeComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent
  prepend LocoMotion::Concerns::LinkableComponent
  prepend LocoMotion::Concerns::IconableComponent

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

    @title = config_option(:title, title)
    
    # Initialize linkable and iconable components
    initialize_linkable_component
    initialize_iconable_component
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
    context = {}
    content_output = ""
    
    # Add left icon if present
    if @left_icon
      context[:left_icon] = helpers.heroicon_tag(@left_icon, **left_icon_html)
      content_output += context[:left_icon]
    end
    
    # Add content/title if present
    if content_provided?
      context[:content] = content
      content_output += context[:content]
    elsif @title
      context[:title] = @title
      content_output += context[:title]
    end
    
    # Add right icon if present
    if @right_icon
      context[:right_icon] = helpers.heroicon_tag(@right_icon, **right_icon_html)
      content_output += context[:right_icon]
    end
    
    part(:component) { content_output.html_safe }
  end

  private

  def setup_component
    set_tag_name(:component, :span)
    add_css(:component, "badge")
    
    # Setup both linkable and iconable components
    setup_linkable_component
    setup_iconable_component
  end
  
  def content_provided?
    content.present?
  end
end
