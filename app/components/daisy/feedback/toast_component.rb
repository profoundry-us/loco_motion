#
# The ToastComponent provides a container for displaying non-critical messages
# to users, typically positioned at the edges of the viewport. Toasts are
# commonly used for temporary notifications, success messages, or error alerts
# that don't require immediate user action.
#
# @note Currently, this component only handles positioning. JavaScript
#   functionality for showing/hiding toasts will be implemented in a future
#   Stimulus ToastController.
#
# @loco_example Basic Toast with Alert
#   = daisy_toast do
#     = daisy_alert(icon: "check-circle", css: "alert-success text-white") do
#       Yay! Something went well!
#
# @loco_example Multiple Alerts in Toast
#   = daisy_toast do
#     = daisy_alert(icon: "check-circle", css: "alert-success text-white") do
#       Operation successful!
#
#     = daisy_alert(icon: "exclamation-circle", css: "alert-error text-white") do
#       An error occurred.
#
class Daisy::Feedback::ToastComponent < LocoMotion::BaseComponent
  #
  # Creates a new Toast component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the toast.
  #
  # @option kws css [String] Additional CSS classes for styling. By default,
  #   toasts are positioned in the bottom-right corner of the viewport.
  #   Common options include:
  #   - Position modifiers: `toast-top`, `toast-bottom`, `toast-center`,
  #     `toast-start`, `toast-end`
  #   - Stack order: `z-50`
  #
  def before_render
    add_css(:component, "toast")
  end

  def call
    part(:component) { content }
  end
end
