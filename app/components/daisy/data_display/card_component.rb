#
# The Card component is a flexible container for displaying content with a
# consistent style. It can include images, titles, text, and actions.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @part body The main content area of the card.
# @part title The title text container when using the simple title option.
#
# @slot title A custom title section, typically rendered as an `h2` element.
# @slot top_figure {Daisy::DataDisplay::FigureComponent} An optional figure
#   (usually an image) to display at the top of the card.
# @slot bottom_figure {Daisy::DataDisplay::FigureComponent} An optional figure
#   (usually an image) to display at the bottom of the card.
# @slot actions A container for action buttons or links, typically displayed at
#   the bottom of the card.
#
# @loco_example Basic Usage
#   = daisy_card(title: "Simple Card") do
#     This is a basic card with just a title and some content.
#
# @loco_example With Top Image
#   = daisy_card do |card|
#     - card.with_top_figure(src: "example.jpg")
#     - card.with_title { "Card with Image" }
#     A card with an image at the top and a custom title.
#
# @loco_example With Actions
#   = daisy_card do |card|
#     - card.with_title { "Interactive Card" }
#     This card has buttons for user interaction.
#     - card.with_actions do
#       = daisy_button("Learn More")
#       = daisy_button("Share")
#
# @loco_example Complex Layout
#   = daisy_card do |card|
#     - card.with_top_figure(src: "header.jpg")
#     - card.with_title do
#       .flex.items-center.gap-2
#         = heroicon "star"
#         Featured Article
#     %p{ class: "text-base-content/70" } A beautifully designed card with rich content.
#     - card.with_bottom_figure(src: "footer.jpg")
#     - card.with_actions do
#       .flex.justify-between.w-full
#         = daisy_button("Read More")
#         .flex.gap-2
#           = daisy_button(icon: "heart", tip: "Like")
#           = daisy_button(icon: "share", tip: "Share")
#
class Daisy::DataDisplay::CardComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent
  include LocoMotion::Concerns::LinkableComponent

  renders_one :title, LocoMotion::BasicComponent.build(tag_name: :h2, css: "card-title")
  renders_one :top_figure, Daisy::DataDisplay::FigureComponent.build(css: "card-image")
  renders_one :bottom_figure, Daisy::DataDisplay::FigureComponent.build(css: "card-image")
  renders_one :actions, LocoMotion::BasicComponent.build(css: "card-actions")

  define_part :body

  # @return [String] The title text when using the simple title option.
  attr_reader :simple_title

  # Creates a new card component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws title [String] Optional simple title text. For more complex
  #   titles, use the `with_title` method instead.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Image Side: `image-full` (image becomes background)
  #   - Borders: `card-border`
  #   - Sizes: `card-sm` (less padding)
  #   - Colors: `bg-base-100`, `bg-primary`, `bg-secondary`
  #
  # @option kws tip [String] The tooltip text to display when hovering over
  #   the component.
  #
  def initialize(**kws, &block)
    super

    @simple_title = kws[:title]
  end

  def before_render
    setup_component
    super # Runs TippableComponent's setup hook

    with_title { simple_title } if simple_title && !title?
  end

  private

  def setup_component
    add_css(:component, "card")
    add_css(:body, "card-body")
  end
end
