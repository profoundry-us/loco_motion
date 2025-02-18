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
# @slot top_figure An optional figure (usually an image) to display at the top
#   of the card.
# @slot bottom_figure An optional figure (usually an image) to display at the
#   bottom of the card.
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
#         = heroicon_tag "star"
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
  prepend LocoMotion::Concerns::TippableComponent

  # A component for rendering figures (usually images) within the card.
  #
  # @part image The image element when a source URL is provided.
  #
  Figure = LocoMotion::BasicComponent.build do
    define_part :image, tag_name: :img, css: "card-image"

    # Creates a new figure component.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws src [String] URL of the image to display in the figure.
    #
    def initialize(**kws, &block)
      super

      @src = kws[:src]
    end

    def before_render
      set_tag_name(:component, :figure)
      add_html(:image, src: @src) if @src
    end

    def call
      part(:component) do
        if @src
          part(:image)
        else
          content
        end
      end
    end
  end

  define_parts :body, :title

  renders_one :title, LocoMotion::BasicComponent.build(tag_name: :h2, css: "card-title")
  renders_one :top_figure, Figure
  renders_one :bottom_figure, Figure
  renders_one :actions, LocoMotion::BasicComponent.build(css: "card-actions")

  # @return [String] The title text when using the simple title option.
  attr_reader :simple_title

  # Creates a new card component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws title [String] The text to display in the card's title section.
  #   You can also provide custom title content using the title slot.
  #
  def initialize(**kws, &block)
    super

    @simple_title = kws[:title]
  end

  def before_render
    setup_component
    setup_body
  end

  def setup_component
    add_css(:component, "card")
  end

  def setup_body
    add_css(:body, "card-body")
  end
end
