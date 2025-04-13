#
# The StatusComponent displays a small icon to visually show the current status of an element,
# such as online, offline, error, etc. It follows the DaisyUI status component pattern.
#
# @loco_example Basic Status
#   = daisy_status()
#
# @loco_example Status with Size
#   = daisy_status(css: "status-xs")
#   = daisy_status(css: "status-sm")
#   = daisy_status(css: "status-md")
#   = daisy_status(css: "status-lg")
#   = daisy_status(css: "status-xl")
#
# @loco_example Status with Color
#   = daisy_status(css: "status-primary")
#   = daisy_status(css: "status-secondary")
#   = daisy_status(css: "status-accent")
#   = daisy_status(css: "status-info")
#   = daisy_status(css: "status-success")
#   = daisy_status(css: "status-warning")
#   = daisy_status(css: "status-error")
#
# @loco_example Status with Accessibility
#   = daisy_status(css: "status-success", html: { aria: { label: "Status: Online" } })
#
# @!parse class Daisy::DataDisplay::StatusComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::StatusComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent

  def initialize(**kws)
    super(**kws)
  end

  def before_render
    setup_component
    super # Call super after setup
  end

  def call
    part(:component)
  end

  private

  def setup_component
    add_css(:component, "status")
  end
end
