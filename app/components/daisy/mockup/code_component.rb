#
# The CodeComponent creates stylized code blocks for displaying code snippets,
# terminal output, or any text that benefits from monospace formatting.
# Common use cases include:
# - Displaying code examples.
# - Showing terminal commands and output.
# - Highlighting important configuration settings.
# - Creating interactive tutorials.
#
# The component supports line prefixes (e.g., for line numbers or command
# prompts), syntax highlighting via CSS classes, and multi-line code blocks.
#
# @slot lines+ [Daisy::Mockup::CodeLineComponent] Individual lines of code,
#   each with optional prefix and styling.
#
# @loco_example Basic Command with Prefix
#   = daisy_code(prefix: "$") do
#     yarn add @profoundry-us/loco_motion
#
# @loco_example Multi-line Terminal Output
#   = daisy_code do |code|
#     - code.with_line(prefix: "$") do
#       npm install
#     - code.with_line(prefix: ">", css: "text-warning") do
#       Installing packages...
#     - code.with_line(prefix: ">", css: "text-success") do
#       Done in 2.45s
#
# @loco_example Code Block with Highlighting
#   = daisy_code do |code|
#     - code.with_line(prefix: "1") do
#       def hello_world
#     - code.with_line(prefix: "2", css: "bg-warning") do
#       puts "Hello, world!"
#     - code.with_line(prefix: "3") do
#       end
#
# @loco_example Plain Code Block
#   = daisy_code do
#     :plain
#       class Example
#         def initialize
#           @value = 42
#         end
#       end
#
class Daisy::Mockup::CodeComponent < LocoMotion::BaseComponent

  #
  # A component for rendering individual lines within a code block.
  #
  # @part code The code content for this line.
  #
  class Daisy::Mockup::CodeLineComponent < LocoMotion::BaseComponent
    define_parts :code

    #
    # Creates a new code line.
    #
    # @option kws prefix [String] Optional prefix for the line (e.g., "$",
    #   ">", or line numbers).
    # @option kws css [String] Additional CSS classes for styling the line.
    #
    def initialize(**kws)
      super(**kws)

      @prefix = config_option(:prefix)
    end

    #
    # Sets up the component's HTML tags and attributes.
    #
    def before_render
      set_tag_name(:component, :pre)
      set_tag_name(:code, :code)

      add_html(:component, { "data-prefix": @prefix }) if @prefix
    end

    #
    # Renders the line with its code content.
    #
    def call
      part(:component) do
        part(:code) do
          content
        end
      end
    end
  end

  define_parts :pre, :code
  renders_many :lines, Daisy::Mockup::CodeLineComponent

  #
  # Creates a new code block component.
  #
  # @option kws prefix [String] Optional prefix for all lines (if not using
  #   individual line prefixes).
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Size: `w-full`, `max-w-3xl`
  #   - Background: `bg-base-300`, `bg-neutral`
  #   - Text: `text-sm`, `text-base-content`
  #
  def initialize(**kws)
    super(**kws)

    @prefix = config_option(:prefix)
  end

  #
  # Sets up the component's CSS classes and HTML attributes.
  #
  def before_render
    add_css(:component, "mockup-code")

    set_tag_name(:pre, :pre)
    set_tag_name(:code, :code)

    add_html(:pre, { "data-prefix": @prefix }) if @prefix

    # If the prefix is blank, add some left margin and hide the :before
    # pseudo-element used for the prefix
    add_css(:pre, "before:!hidden ml-6") if @prefix.blank?
  end

  #
  # Renders the code block with its lines or direct content.
  #
  def call
    part(:component) do
      if lines.any?
        lines.each { |line| concat(line) }
      else
        part(:pre) do
          part(:code) do
            content
          end
        end
      end
    end
  end
end
