#
# The Text Rotate component displays up to 6 lines of text, one at a time,
# with an infinite loop CSS animation. The duration is 10 seconds by default
# and the animation pauses on hover. Common use cases include rotating hero
# headlines, cycling through feature keywords, or animating taglines on
# marketing pages.
#
# @slot item+ Multiple text items to display in the rotation. Each item will
#   be displayed one at a time in an infinite loop.
#
# @param texts [Array<String>] An optional array of strings for simple usage
#   without blocks. When provided, each string is rendered as a span inside
#   the rotation.
#
# @loco_example Basic Text Rotate
#   = daisy_text_rotate do |rotate|
#     - rotate.with_item { "ONE" }
#     - rotate.with_item { "TWO" }
#     - rotate.with_item { "THREE" }
#
# @loco_example Text Rotate with texts Shorthand
#   = daisy_text_rotate(texts: %w[DESIGN DEVELOP DEPLOY SCALE MAINTAIN REPEAT], css: "text-7xl")
#
# @loco_example Text Rotate with Centered Items
#   = daisy_text_rotate(css: "text-7xl", container_css: "justify-items-center") do |rotate|
#     - rotate.with_item { "DESIGN" }
#     - rotate.with_item { "DEVELOP" }
#     - rotate.with_item { "DEPLOY" }
#
# @loco_example Text Rotate with Custom Duration
#   = daisy_text_rotate(css: "text-7xl duration-6000") do |rotate|
#     - rotate.with_item { "BLAZING" }
#     - rotate.with_item(css: "font-bold italic") { "FAST" }
#
# @loco_example Text Rotate Inline in a Sentence
#   %span Providing AI Agents for
#   = daisy_text_rotate do |rotate|
#     - rotate.with_item(css: "bg-teal-400 text-teal-800 px-2") { "Designers" }
#     - rotate.with_item(css: "bg-red-400 text-red-800 px-2") { "Developers" }
#     - rotate.with_item(css: "bg-blue-400 text-blue-800 px-2") { "Managers" }
#
class Daisy::DataDisplay::TextRotateComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent

  set_component_name :text_rotate

  # A component for rendering individual text items within the rotation.
  class ItemComponent < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "text-rotate-item")
    end
  end

  renders_many :items, ItemComponent

  attr_reader :texts, :container_css

  #
  # Creates a new Text Rotate component.
  #
  # @param texts [Array<String>] An optional array of strings for simple usage.
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws [String] :container_css CSS classes to apply to the container.
  # @option kws [String] :tip The tooltip text to display when hovering over
  #   the component.
  #
  def initialize(texts: nil, container_css: nil, **kws, &block)
    super(**kws, &block)

    @texts = texts
    @container_css = container_css

    set_tag_name(:component, :span)
  end

  def before_render
    super

    setup_component
    setup_texts if texts
  end

  private

  def setup_component
    add_css(:component, "text-rotate")
  end

  def setup_texts
    texts.each do |text|
      with_item { text }
    end
  end
end
