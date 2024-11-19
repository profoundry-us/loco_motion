#
# The HeroComponent is a layout component that is used to create a hero section.
#
# @part content_wrapper The wrapper for the content of the hero.
#
# @slot overlay [LocoMotion::BasicComponent] An optional `<div>` positioned to
#   overlay underneath the hero and allow for styling behind it.
#
class Daisy::Layout::HeroComponent < LocoMotion::BaseComponent
  define_part :content_wrapper

  renders_one :overlay, LocoMotion::BasicComponent.build(css: "hero-overlay")

  #
  # Adds the necessary CSS classes to the component.
  #
  def before_render
    add_css(:component, "hero")
    add_css(:content_wrapper, "hero-content")
  end
end
