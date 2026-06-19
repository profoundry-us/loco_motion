# frozen_string_literal: true

#
# The ToastComponent provides a container for displaying non-critical messages
# to users, typically positioned at the edges of the viewport. Toasts are
# commonly used for temporary notifications, success messages, or error alerts
# that don't require immediate user action.
#
# @note This component only handles positioning. For show/hide behavior, use
#   the {Daisy::Feedback::AlertComponent} options on the alerts inside the
#   toast — `autoclose` (with `timeout`) auto-dismisses an alert and `closable`
#   renders a manual close button, both driven by the `loco-alert` Stimulus
#   controller. As with `loco-theme`, the consuming app must register that
#   controller (the npm package's `AlertController`) for dismissal to work.
#
# @loco_example Basic Toast with Alert
#   = daisy_toast do
#     = daisy_alert(icon: "check-circle", css: "alert-success text-white") do
#       Yay! Something went well!
#
# @loco_example Auto-dismissing, Closable Toast
#   = daisy_toast(css: "toast-top toast-start") do
#     = daisy_alert(icon: "check-circle", css: "alert-success", autoclose: true, timeout: 4000, closable: true) do
#       Saved!
#
# @loco_example Multiple Alerts in Toast
#   = daisy_toast do
#     = daisy_alert(icon: "check-circle", css: "alert-success text-white") do
#       Operation successful!
#
#     = daisy_alert(icon: "exclamation-circle", css: "alert-error text-white") do
#       An error occurred.
#
module Daisy
  module Feedback
    class ToastComponent < LocoMotion::BaseComponent
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
  end
end
