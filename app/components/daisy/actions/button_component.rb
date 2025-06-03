#
# The Button component can be used to render HTML `<button>` or `<a>` elements
# that are styled to look like a clickable element.
#
# Note that we do **not** use component parts for the icons since we're calling
# `heroicon` within the component. But we **do** provide custom CSS & HTML
# options to allow overriding / customization.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @loco_example Basic Usage
#   = daisy_button("Click Me")
#
#   = daisy_button do
#     Click Me Too
#
#   = daisy_button(icon: "heart", tip: "Love")
#
#   = daisy_button(title: "Button with Two Icons", left_icon: "heart", right_icon: "plus")
#
# @loco_example Button Group
#   = daisy_button_group do
#     = daisy_button do
#       Button 1
#     = daisy_button do
#       Button 2
#
# @loco_example Default Button
#   = daisy_button { "Default Button" }
#
# @loco_example Primary Button
#   = daisy_button(css: "btn-primary") { "Primary Button" }
#
# @loco_example Secondary Button
#   = daisy_button(css: "btn-secondary") { "Secondary Button" }
#
# @loco_example Accent Button
#   = daisy_button(css: "btn-accent") { "Accent Button" }
#
# @loco_example Ghost Button
#   = daisy_button(css: "btn-ghost") { "Ghost Button" }
#
# @loco_example Link Button
#   = daisy_button(css: "btn-link") { "Link Button" }
#
# @loco_example Info Button
#   = daisy_button(css: "btn-info") { "Info Button" }
#
# @loco_example Success Button
#   = daisy_button(css: "btn-success") { "Success Button" }
#
# @loco_example Warning Button
#   = daisy_button(css: "btn-warning") { "Warning Button" }
#
# @loco_example Error Button
#   = daisy_button(css: "btn-error") { "Error Button" }
#
# @loco_example Outline Primary Button
#   = daisy_button(css: "btn-primary btn-outline") { "Outline Primary" }
#
# @loco_example Outline Success Button
#   = daisy_button(css: "btn-success btn-outline") { "Outline Success" }
#
# @loco_example Outline Warning Button
#   = daisy_button(css: "btn-warning btn-outline") { "Outline Warning" }
#
# @loco_example Outline Error Button
#   = daisy_button(css: "btn-error btn-outline") { "Outline Error" }
#
# @loco_example Soft Primary Button
#   = daisy_button(css: "btn-primary btn-soft") { "Soft Primary" }
#
# @loco_example Soft Success Button
#   = daisy_button(css: "btn-success btn-soft") { "Soft Success" }
#
# @loco_example Soft Warning Button
#   = daisy_button(css: "btn-warning btn-soft") { "Soft Warning" }
#
# @loco_example Soft Error Button
#   = daisy_button(css: "btn-error btn-soft") { "Soft Error" }
#
# @loco_example Dash Primary Button
#   = daisy_button(css: "btn-primary btn-dash") { "Dash Primary" }
#
# @loco_example Dash Success Button
#   = daisy_button(css: "btn-success btn-dash") { "Dash Success" }
#
# @loco_example Dash Warning Button
#   = daisy_button(css: "btn-warning btn-dash") { "Dash Warning" }
#
# @loco_example Dash Error Button
#   = daisy_button(css: "btn-error btn-dash") { "Dash Error" }
#
# @loco_example Wide Button
#   = daisy_button(css: "btn-wide") { "Wide Button" }
#
class Daisy::Actions::ButtonComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent
  include LocoMotion::Concerns::LinkableComponent
  include LocoMotion::Concerns::IconableComponent

  define_parts :label

  #
  # Instantiate a new Button component.
  #
  # @param title  [String] The title of the button. Defaults to "Submit" if none
  #   of title, left icon, or right icon is provided. Will be considered the
  #   `action` parameter if **both** the title and a block are provided.
  #
  # @param kws    [Hash] The keyword arguments for the component.
  #
  # @option kws title           [String] The title of the button. You can also
  #   pass the title, icons, or any other HTML content as a block.
  #
  # @option kws href            [String] A path or URL to which the user will be
  #   directed when the button is clicked. Forces the Button to use an `<a>`
  #   tag.
  #
  #   > **Note:** _You should use either the `action` or the `href` option, but
  #   not both._
  #
  # @option kws target          [String] The HTML `target` of for the `<a>` tag
  #   (`_blank`, `_parent`, or a specific tab / window / iframe, etc).
  #
  # @option kws icon            [String] The name of Hero icon to render inside
  #   the button.  This is an alias of `left_icon`.
  #
  # @option kws icon_css        [String] The CSS classes to apply to the icon.
  #   This is an alias of `left_icon_css`.
  #
  # @option kws icon_html       [Hash] Additional HTML attributes to apply to
  #   the icon. This is an alias of `left_icon_html`.
  #
  # @option kws left_icon       [String] The name of Hero icon to render inside
  #   the button to the left of the text.
  #
  # @option kws left_icon_css   [String] The CSS classes to apply to the left
  #   icon.
  #
  # @option kws left_icon_html  [Hash] Additional HTML attributes to apply to
  #   the left icon.
  #
  # @option kws right_icon      [String] The name of Hero icon to render inside
  #   the button to the right of the text.
  #
  # @option kws right_icon_css  [String] Right icon CSS (via IconableComponent).
  #
  # @option kws right_icon_html [Hash] Right icon HTML (via IconableComponent).
  #
  def initialize(title = nil, action = nil, **kws, &block)
    super

    # If both a title and a block are provided, assume the title is the action
    action = title if title && block_given?

    # Force the title to be nil if a block is given so we don't accidentally
    # render two titles
    title = nil if block_given?

    @action = config_option(:action, action)

    # Initialize concerns -- handled by BaseComponent hook
    default_title = @left_icon || @right_icon ? nil : "Submit"
    @simple_title = config_option(:title, title || default_title)
  end

  #
  # Calls the {setup_component} method before rendering the component.
  #
  def before_render
    # Run before the super so LinkableComponent can override our tag name
    setup_component

    super
  end

  #
  # Performs button-specific setup. Adds the `btn` CSS class to the component.
  # Also adds `items-center` and `gap-2` CSS classes if an icon is present.
  # Tag name setup (`<a>` vs `<button>`) and tooltip setup are handled by
  # LinkableComponent and TippableComponent concerns via BaseComponent hooks.
  #
  def setup_component
    # Ensure tag is button if LinkableComponent didn't set it to <a>
    set_tag_name(:component, :button)

    # Add the btn class
    add_css(:component, "btn") unless @skip_styling

    # Add data-action if specified
    add_html(:component, { "data-action": @action }) if @action
  end
end
