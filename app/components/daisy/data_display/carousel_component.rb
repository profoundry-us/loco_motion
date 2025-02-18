#
# The Carousel component displays a horizontal scrolling list of items, such as
# images, cards, or any other content. It's useful for showcasing multiple
# items in a space-efficient manner.
#
# @slot item+ Multiple items to display in the carousel. Each item will be
#   displayed side by side and can be scrolled horizontally.
#
# @loco_example Basic Usage with Images
#   = daisy_carousel do |carousel|
#     - carousel.with_item do
#       %img{ src: "image1.jpg", class: "w-full" }
#     - carousel.with_item do
#       %img{ src: "image2.jpg", class: "w-full" }
#     - carousel.with_item do
#       %img{ src: "image3.jpg", class: "w-full" }
#
# @loco_example With Cards
#   = daisy_carousel do |carousel|
#     - carousel.with_item do
#       = daisy_card(title: "Card 1") do
#         First card content
#     - carousel.with_item do
#       = daisy_card(title: "Card 2") do
#         Second card content
#
# @loco_example With Custom Styling
#   = daisy_carousel(css: "h-96 rounded-box") do |carousel|
#     - carousel.with_item(css: "w-1/2") do
#       .bg-primary.text-primary-content.p-4.h-full
#         %h2.text-2xl First Slide
#         %p Some content for the first slide
#     - carousel.with_item(css: "w-1/2") do
#       .bg-secondary.text-secondary-content.p-4.h-full
#         %h2.text-2xl Second Slide
#         %p Some content for the second slide
#
class Daisy::DataDisplay::CarouselComponent < LocoMotion::BaseComponent
  # A component for rendering individual items within the carousel.
  class ItemComponent < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "carousel-item")
    end
  end

  renders_many :items, ItemComponent

  def before_render
    setup_component
  end

  def setup_component
    add_css(:component, "carousel")
  end
end
