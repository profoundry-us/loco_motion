# This is the avatar component.
class Daisy::DataDisplay::AvatarComponent < LocoMotion.configuration.base_component_class
  set_component_name :avatar

  define_parts :wrapper, :img, :span, :placeholder

  # Create a new avatar component.
  def initialize(*args, **kws, &block)
    super

    @src = config_option(:src)
    set_tag_name(:component, :div)
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    add_css(:component, "avatar")
    add_css(:wrapper, "w-24 rounded-full")

    if @src.nil?
      add_css(:component, "placeholder")
      add_css(:wrapper, "bg-neutral text-neutral-content")

    else
      set_tag_name(:img, :img)
      add_html(:img, { src: @src, title: @content })
    end
  end
end
