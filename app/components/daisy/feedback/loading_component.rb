#
# The LoadingComponent displays an animated indicator to show that a process is
# running in the background. It supports multiple animation styles and can be
# customized with different colors and sizes.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @loco_example Basic Loading Spinners
#   = daisy_loading(css: "loading-spinner text-primary")
#   = daisy_loading(css: "loading-dots text-secondary")
#   = daisy_loading(css: "loading-ring text-accent")
#
# @loco_example Other Loading Styles
#   = daisy_loader(css: "loading-ball text-info")
#   = daisy_loader(css: "loading-bars text-success")
#   = daisy_loader(css: "loading-infinity text-error")
#
# @note The helper method is also aliased as `daisy_loader` for better
#   readability, but CSS classes must still use the `loading-*` prefix.
#
class Daisy::Feedback::LoadingComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent

  #
  # Creates a new Loading component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the loader.
  #
  # @option kws css   [String] Additional CSS classes for the loader. Available
  #   styles include: `loading-spinner`, `loading-dots`, `loading-ring`,
  #   `loading-ball`, `loading-bars`, and `loading-infinity`. Can be combined
  #   with color classes like `text-primary` or `text-success`.
  #
  # @option kws tip   [String] Optional tooltip text to display when hovering
  #   over the loader. Added by the TippableComponent module.
  #
  def initialize(*args, **kws, &block)
    super
  end

  def before_render
    setup_component
    super
  end
  
  def call
    part(:component)
  end
  
  private
  
  def setup_component
    add_css(:component, "loading")
  end
end
