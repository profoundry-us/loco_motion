#
# The Daisy::Navigation::LinkComponent is a simple component that renders an
# anchor tag.
#
class Daisy::Navigation::LinkComponent < LocoMotion.configuration.base_component_class

  # Create a new instance of the LinkComponent.
  #
  # If passed **two** positional arguments, the first is considered the `text`
  # and the second is considered the `href`. If passed only **one** positional
  # argument, it is treated as the `href` and we assume the `text` will be
  # provided in the block. `target` is always a keyword argument.
  #
  # @param text [String] The text to display in the link.
  # @param href [String] The URL to visit when the link is clicked.
  # @param target [String] The target attribute for the anchor tag.
  def initialize(*args, **kws, &block)
    super

    @text = config_option(:text, args.size == 2 ? args[0] : nil)
    @href = config_option(:href, args.size == 2 ? args[1] : args[0])
    @target = config_option(:target)
  end

  #
  # Adds the relevant Daisy classes and applies the href and target attributes
  # if provided.
  #
  def before_render
    set_tag_name(:component, :a)
    add_css(:component, "link")
    add_html(:component, { href: @href }) if @href
    add_html(:component, { target: @target }) if @target
  end
end
