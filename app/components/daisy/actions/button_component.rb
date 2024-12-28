#
# The Button component can be used to render HTML `<button>` or `<a>` elements
# that are styled to look like a clickable element.
#
# Note we do **not** use component parts for the icons since we're calling
# `heroicon_tag` within the component.
#
# @loco_example Basic Usage
#   = daisy_button("Click Me")
#
#   = daisy_button do
#     Click Me Too
#
#   = daisy_button(icon: "heart")
#
#   = daisy_button(title: "Button with Two Icons", left_icon: "heart", right_icon: "heart")
#
class Daisy::Actions::ButtonComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  set_component_name :btn

  #
  # Instantiate a new Button component.
  #
  # @param args [Array] Allows passing of the title as the first argument.
  # @param kws  [Hash] The keyword arguments for the component.
  #
  # @option args title [String] The title of the button.
  #
  # @option kws href            [String] A path or URL to which the user will be
  #   directed when the button is clicked. Forces the Button to use an `<a>` tag.
  # @option kws target          [String] The HTML `target` of for the `<a>` tag
  #   (`_blank`, `_parent`, or a specific tab / window / iframe, etc).
  # @option kws icon            [String] The name of Hero icon to render inside
  #   the button. This is an alias of `left_icon`.
  # @option kws icon_css        [String] The CSS classes to apply to the icon.
  #   This is an alias of `left_icon_css`.
  # @option kws icon_html       [Hash] Additional HTML attributes to apply to the
  #   icon. This is an alias of `left_icon_html`.
  # @option kws left_icon       [String] The name of Hero icon to render inside
  #   the button to the left of the text.
  # @option kws left_icon_css   [String] The CSS classes to apply to the icon.
  # @option kws left_icon_html  [Hash] Additional HTML attributes to apply to
  #   the icon.
  # @option kws right_icon      [String] The name of Hero icon to render inside
  #   the button to the right of the text.
  # @option kws right_icon_css  [String] The CSS classes to apply to the icon.
  # @option kws right_icon_html [Hash] Additional HTML attributes to apply to
  #   the icon.
  # @option kws title           [String] The title of the button. You can also
  #   pass the title, icons, or any other HTML content as a block.
  #
  def initialize(*args, **kws, &block)
    super

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
    @simple_title = config_option(:title, args[0] || default_title)
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
