#
# Creates a styled link component that can be used for navigation or inline text
# links. This component is designed to work similarly to Rails' `link_to` helper.
#
# @example Link with custom styling
#   = daisy_link "Components", "#", css: "link-primary text-xl"
#
# @example Link with block content
#   = daisy_link "#", css: "link-hover" do
#     = hero_icon("home")
#     Home
#
# @example Link with positional arguments
#   = daisy_link "Documentation", "#"
#
# @example Basic link with keyword arguments
#   = daisy_link(title: "Home", href: "#")
#
class Daisy::Navigation::LinkComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  # Create a new instance of the LinkComponent.
  #
  # @param args [Array] Looks for **one** or **two** positional arguments.
  #   - If passed **two** positional arguments, the first is considered the `title`
  #   and the second is considered the `href`.
  #   - If passed only **one** positional argument, it is treated as the `href`
  #   and we assume the `title` will be provided in the block.
  #   - If no text is passed in the block, we will use the `href` as the title.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws title [String] The text to display in the link. Not required if
  #   providing block content.
  #
  # @option kws href [String] The URL to visit when the link is clicked.
  #
  # @option kws target [String] The target attribute for the anchor tag (e.g., "_blank").
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Style: `link-primary`, `link-secondary`, `link-accent`
  #   - State: `link-hover`
  #   - Text: `text-sm`, `text-xl`, `text-2xl`
  #
  def initialize(*args, **kws)
    super

    if args.size == 1
      # If given one arg, assume it's the href and / or the title (if no block is given)
      @title = args[0]
      @href = args[0]
    elsif args.size == 2
      # If given two args, assume the first is the title and the second is the href
      @title = args[0]
      @href = args[1]
    else
      # Otherwise, assume they pass everything as keyword arguments
      @title = config_option(:title)
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
    part(:component) { content || @title }
  end
end
