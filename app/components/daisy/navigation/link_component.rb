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
  # provided in the block. If no text is passed, we will use the href as the
  # text `target` is always a keyword argument.
  #
  # @param text [String] The text to display in the link.
  # @param href [String] The URL to visit when the link is clicked.
  # @param target [String] The target attribute for the anchor tag.
  def initialize(*args, **kws, &block)
    super

    if args.size == 1
      # If given one arg, assume it's the href and / or the text (if no block is given)
      if block_given?
        @href = args[0]
      else
        @text = args[0]
        @href = args[0]
      end
    elsif args.size == 2
      # If given two args, assume the first is the text and the second is the href
      @text = args[0]
      @href = args[1]
    else
      # Otherwise, assume they pass everything as keyword arguments
      @text = config_option(:text)
      @href = config_option(:href)
    end

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

  #
  # Renders the link component.
  #
  # Because this is an inline component which might be utlized alongside text,
  # we utilize the `call` method instead of a template to ensure that no
  # additional whitespace gets added to the output.
  #
  def call
    part(:component) { @text || content }
  end
end
