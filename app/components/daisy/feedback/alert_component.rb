#
# The AlertComponent displays an important message to users. It can be used to
# show information, success messages, warnings, or errors. Alerts can include
# an optional icon at the start and customizable content.
#
# @part icon             [Heroicon] An optional icon displayed at the start of
#   the alert. Uses the Heroicon system.
#
# @part content_wrapper  [HTML] A wrapper for the main content of the alert.
#   This allows for proper spacing and alignment with the icon.
#
# @loco_example Basic Alert
#   = daisy_alert do
#     This is a standard alert message.
#
# @loco_example Alert with Icon
#   = daisy_alert(icon: "information-circle", icon_html: { variant: :outline }) do
#     Here's some important information!
#
# @loco_example Alert Types
#   = daisy_alert(icon: "information-circle", css: "alert-info", icon_html: { variant: :outline }) do
#     Information alert.
#
#   = daisy_alert(icon: "check-circle", css: "alert-success", icon_html: { variant: :outline }) do
#     Success alert.
#
#   = daisy_alert(icon: "exclamation-triangle", css: "alert-warning", icon_html: { variant: :outline }) do
#     Warning alert.
#
#   = daisy_alert(icon: "exclamation-circle", css: "alert-error", icon_html: { variant: :outline }) do
#     Error alert.
#
class Daisy::Feedback::AlertComponent < LocoMotion::BaseComponent
  define_parts :icon, :content_wrapper

  #
  # Creates a new Alert component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the alert.
  #
  # @option kws icon      [String] The name of the Heroicon to display at the
  #   start of the alert.
  #
  # @option kws icon_html [Hash] Additional HTML attributes for the icon
  #   element. Options include `variant: :outline` or `variant: :solid`.
  #
  # @option kws css      [String] Additional CSS classes for the alert. Use
  #   `alert-info`, `alert-success`, `alert-warning`, or `alert-error` for
  #   different alert types.
  #
  def initialize(*args, **kws, &block)
    super

    @icon = config_option(:icon)
  end

  def before_render
    add_css(:component, "alert")
    add_html(:component, { role: "alert" })

    add_css(:icon, "where:size-8")
  end
end
