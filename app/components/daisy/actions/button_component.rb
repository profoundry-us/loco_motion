#
# The Button component can be used to render HTML `<button>` or `<a>` elements
# that are styled to look like a clickable element.
#
# Note that we do **not** use component parts for the icons since we're calling
# `heroicon_tag` within the component. But we **do** provide custom CSS & HTML
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
class Daisy::Actions::ButtonComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  #
  # Instantiate a new Button component.
  #
  # @param title  [String] The title of the button. Defaults to "Submit" if none
  #   of title, left icon, or right icon is provided. Will be considered the
  #   `action` parameter if **both** the title and a block are provided.
  #
  # @param action [String] The Stimulus action that should fire when the button
  #   is clicked.
  #
  # @param kws    [Hash] The keyword arguments for the component.
  #
  # @option kws title           [String] The title of the button. You can also
  #   pass the title, icons, or any other HTML content as a block.
  #
  # @option kws action          [String] The Stimulus action that should fire
  #   when the button is clicked.
  #
  #   > **Note:** _You should use either the `action` or the `href` option, but
  #   not both._
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
  # @option kws right_icon_css  [String] The CSS classes to apply to the right
  #   icon.
  #
  # @option kws right_icon_html [Hash] Additional HTML attributes to apply to
  #   the right icon.
  #
  def initialize(title = nil, action = nil, **kws, &block)
    super

    # If both a title and a block are provided, assume the title is the action
    action = title if title && block_given?

    # Force the title to be nil if a block is given so we don't accidentally
    # render two titles
    title = nil if block_given?

    @action = config_option(:action, action)

    @href = config_option(:href)
    @target = config_option(:target)

    @icon = config_option(:icon)
    @icon_css = config_option(:icon_css, "[:where(&)]:size-5")
    @icon_html = config_option(:icon_html, {})

    @left_icon = config_option(:left_icon, @icon)
    @left_icon_css = config_option(:left_icon_css, @icon_css)
    @left_icon_html = config_option(:left_icon_html, @icon_html)

    @right_icon = config_option(:right_icon)
    @right_icon_css = config_option(:right_icon_css, @icon_css)
    @right_icon_html = config_option(:right_icon_html, @icon_html)

    default_title = @left_icon || @right_icon ? nil : "Submit"
    @simple_title = config_option(:title, title || default_title)
  end

  #
  # Calls the {setup_component} method before rendering the component.
  #
  def before_render
    setup_component
  end

  #
  # Sets the tagname to `<a>` if an `href` is provided, otherwise sets it to
  # `<button>`. Adds the `btn` CSS class to the component. Also adds
  # `items-center` and `gap-2` CSS classes if an icon is present.
  #
  def setup_component
    if @href
      set_tag_name(:component, :a)
      add_html(:component, { href: @href, target: @target })
    else
      set_tag_name(:component, :button)
    end

    add_css(:component, "btn")

    if @icon || @left_icon || @right_icon
      add_css(:component, "[:where(&)]:items-center [:where(&)]:gap-2")
    end

      add_html(:component, { "data-action": @action }) if @action
  end

  #
  # Returns the HTML attributes for the left icon.
  #
  def left_icon_html
    { class: @left_icon_css }.merge(@left_icon_html)
  end

  #
  # Returns the HTML attributes for the right icon.
  #
  def right_icon_html
    { class: @right_icon_css }.merge(@right_icon_html)
  end
end
