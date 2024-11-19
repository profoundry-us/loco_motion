# The Avatar Component displays in image, icon, or placeholder text to represent
# a user.
#
# It utilizes the CSS `where()` pseudo-class to reduce the specificity to 0 to
# allow for easy overriding while giving you some sane defaults.
#
# - Width: <code>w-24</code> (can override with w-10, h-10, etc.)
# - Corners: `rounded-full`
#
# If no image is provided, these additional classes will be added so that any
# text or icons are visible.
#
# - Background: +bg-neutral+
# - Text Color: `text-neutral-content`
#
# ## Examples
#
# ```language-haml
# - # Display an avatar with an image
# = daisy_avatar src: "https://example.com/avatar.jpg"
#
# - # Display an avatar with an icon
# = daisy_avatar icon: "user", icon_css: "text-yellow-400"
# ```
#
class Daisy::DataDisplay::AvatarComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  set_component_name :avatar

  define_parts :wrapper, :img, :icon, :placeholder

  # Create a new avatar component.
  def initialize(*args, **kws, &block)
    super

    @src = config_option(:src)
    @icon = config_option(:icon)
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    add_css(:component, "avatar")

    # The where pseudo class reduces the specificity of the CSS selector to 0 so
    # that other Tailwind classes provided by the user will take presedence.
    add_css(:wrapper, "[:where(&)]:w-24 [:where(&)]:rounded-full")

    if @src.present?
      set_tag_name(:img, :img)
      add_html(:img, { src: @src, title: @content })
    else
      add_css(:component, "placeholder")
      add_css(:wrapper, "[:where(&)]:bg-neutral [:where(&)]:text-neutral-content")
    end
  end
end
