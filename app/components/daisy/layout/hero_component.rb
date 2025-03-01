#
# The HeroComponent creates an eye-catching, full-width section typically used
# at the top of a page. Common use cases include:
# - Landing page introductions.
# - Feature showcases.
# - Call-to-action sections.
# - Image-rich banners.
#
# The component is responsive by default and provides flexible layout options
# for content positioning and image integration.
#
# @part content_wrapper [LocoMotion::BaseComponent] The wrapper for the hero
#   content, providing flex-based layout control.
#
# @slot overlay [LocoMotion::BasicComponent] An optional `<div>` positioned
#   behind the content for background effects like semi-transparency or blur.
#
# @loco_example Basic Hero
#   = daisy_hero(css: "bg-base-200 text-center") do
#     %div
#       %h1.text-5xl.font-bold Welcome
#       %p.my-6 Discover amazing features.
#       = daisy_button(css: "btn btn-primary",
#         title: "Get Started")
#
# @loco_example Hero with Image
#   = daisy_hero(css: "bg-base-200",
#     content_wrapper_css: "flex-col md:flex-row") do
#     %img.h-40.rounded{
#       src: image_path("hero-image.jpg"),
#       alt: "Hero Image" }
#     %div
#       %h1.text-5xl.font-bold Features
#       %p.my-6 Explore what we offer.
#
# @loco_example Hero with Background Overlay
#   = daisy_hero(css: "min-h-96",
#     html: { style: "background-image: url('bg.jpg')" }) do |hero|
#     - hero.with_overlay(css: "bg-black/50 backdrop-blur")
#     %div.text-white
#       %h1.text-5xl.font-bold Discover
#       %p.my-6 Start your journey today.
#
class Daisy::Layout::HeroComponent < LocoMotion::BaseComponent
  define_part :content_wrapper

  renders_one :overlay, LocoMotion::BasicComponent.build(css: "hero-overlay")

  #
  # Creates a new Hero component.
  #
  # @param kws [Hash] Keyword arguments for customizing the hero.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Height: `min-h-screen`, `min-h-[50vh]`
  #   - Background: `bg-base-200`, `bg-primary`
  #   - Text: `text-center`, `text-primary-content`
  #
  # @option kws content_wrapper_css [String] CSS classes for the content
  #   wrapper. Common options include:
  #   - Layout: `flex-col`, `flex-col md:flex-row`
  #   - Spacing: `gap-4`, `space-y-4`
  #   - Alignment: `items-center`, `justify-between`
  #
  # @option kws html [Hash] HTML attributes for the hero container.
  #   Commonly used for background images:
  #   ```ruby
  #   html: { style: "background-image: url('image.jpg')" }
  #   ```
  #
  def initialize(**kws)
    super
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "hero")
    add_css(:content_wrapper, "hero-content")
  end
end
