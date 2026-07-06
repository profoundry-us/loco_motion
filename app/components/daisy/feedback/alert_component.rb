# frozen_string_literal: true

#
# The AlertComponent displays an important message to users. It can be used to
# show information, success messages, warnings, or errors. Alerts can include
# an optional icon at the start and customizable content.
#
# @part icon             [String] An optional icon displayed at the start of
#   the alert. Rendered via the `loco_icon` engine.
#
# @part content_wrapper  [HTML] A wrapper for the main content of the alert.
#   This allows for proper spacing and alignment with the icon.
#
# @part close            [Button] A close button that appears when closable is true.
#
# @option kws [String] :style (:default) The style of the alert.
#   [:info, :success, :warning, :error, :default]
# @option kws [Boolean] :soft (false) Use the soft style variant.
# @option kws [Boolean] :outline (false) Use the outline style variant.
# @option kws [Boolean] :dash (false) Use the dash style variant.
# @option kws [Integer] :timeout (nil) Auto-dismiss timeout in milliseconds.
#   If nil, uses global configuration default. If false, no auto-dismiss.
# @option kws [Boolean] :autoclose (false) Enable auto-dismiss using timeout.
#   Must be true for auto-dismiss to work.
# @option kws [String] :href (nil) Converts alert to a clickable link.
# @option kws [String] :action (nil) Stimulus action to fire on click.
# @option kws [Boolean] :closable (false) Show close button. Set to true to enable
#   manual dismissal.
#
# @loco_example Basic Alert
#   = daisy_alert do
#     This is a standard alert message.
#
# @loco_example Alert with Icon
#   = daisy_alert(icon: "information-circle") do
#     Here's some important information!
#
# @loco_example Alert Types
#   = daisy_alert(icon: "information-circle", css: "alert-info") do
#     Information alert.
#
#   = daisy_alert(icon: "check-circle", css: "alert-success") do
#     Success alert.
#
#   = daisy_alert(icon: "exclamation-triangle", css: "alert-warning") do
#     Warning alert.
#
#   = daisy_alert(icon: "exclamation-circle", css: "alert-error") do
#     Error alert.
#
# @loco_example Default
#   = daisy_alert do
#     This is an default alert.
#
# @loco_example Info
#   = daisy_alert(css: "alert-info") do
#     This is an info alert.
#
# @loco_example Success
#   = daisy_alert(css: "alert-success") do
#     This is a success alert.
#
# @loco_example Warning
#   = daisy_alert(css: "alert-warning") do
#     This is a warning alert.
#
# @loco_example Error
#   = daisy_alert(css: "alert-error") do
#     This is an error alert.
#
# @loco_example Soft Info
#   = daisy_alert(css: "alert-info alert-soft") do
#     This is a soft info alert.
#
# @loco_example Soft Success
#   = daisy_alert(css: "alert-success alert-soft") do
#     This is a soft success alert.
#
# @loco_example Soft Warning
#   = daisy_alert(css: "alert-warning alert-soft") do
#     This is a soft warning alert.
#
# @loco_example Soft Error
#   = daisy_alert(css: "alert-error alert-soft") do
#     This is a soft error alert.
#
# @loco_example Outline Info
#   = daisy_alert(css: "alert-info alert-outline") do
#     This is an outline info alert.
#
# @loco_example Outline Success
#   = daisy_alert(css: "alert-success alert-outline") do
#     This is an outline success alert.
#
# @loco_example Outline Warning
#   = daisy_alert(css: "alert-warning alert-outline") do
#     This is an outline warning alert.
#
# @loco_example Outline Error
#   = daisy_alert(css: "alert-error alert-outline") do
#     This is an outline error alert.
#
# @loco_example Dash Info
#   = daisy_alert(css: "alert-info alert-dash") do
#     This is a dash info alert.
#
# @loco_example Dash Success
#   = daisy_alert(css: "alert-success alert-dash") do
#     This is a dash success alert.
#
# @loco_example Dash Warning
#   = daisy_alert(css: "alert-warning alert-dash") do
#     This is a dash warning alert.
#
# @loco_example Dash Error
#   = daisy_alert(css: "alert-error alert-dash") do
#     This is a dash error alert.
#
# @loco_example Closable Alert
#   = daisy_alert(icon: "information-circle", css: "alert-info", closable: true) do
#     This alert can be closed manually.
#
# @loco_example Auto-dismissing Alert
#   = daisy_alert(icon: "check-circle", css: "alert-success", autoclose: true, timeout: 3000) do
#     This alert will auto-dismiss in 3 seconds.
#
# @loco_example Clickable Link Alert
#   = daisy_alert(icon: "information-circle", css: "alert-info", href: "/docs") do
#     Click to view documentation.
#
# @loco_example Stimulus Action Alert
#   = daisy_alert(icon: "exclamation-triangle", css: "alert-warning", action: "click->my-controller#handle") do
#     Click to trigger custom action.
#
module Daisy
  module Feedback
    class AlertComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::IconableComponent
      include LocoMotion::Concerns::LinkableComponent

      define_parts :icon, :content_wrapper, :close

      # @return [Boolean] Whether or not this alert can be closed.
      attr_reader :closable
      alias closable? closable

      #
      # Creates a new Alert component.
      #
      # @param args [Array] Positional arguments passed to the parent class.
      # @param kws  [Hash]  Keyword arguments for customizing the alert.
      #
      # @option kws icon      [String] The name (or `[library:]name[/variant]`
      #   token) of the icon to display at the start of the alert.
      #
      # @option kws icon_html [Hash] Additional HTML attributes for the icon
      #   element, such as `data` or `aria` attributes. To pick an icon
      #   variant, use the icon token instead (e.g. `"check-circle/solid"`).
      #
      # @option kws css      [String] Additional CSS classes for the alert. Use
      #   `alert-info`, `alert-success`, `alert-warning`, or `alert-error` for
      #   different alert types.
      #
      # @option kws style    [String] The style of the alert.
      #   [:info, :success, :warning, :error, :default]
      # @option kws soft     [Boolean] Use the soft style variant.
      # @option kws outline  [Boolean] Use the outline style variant.
      # @option kws dash     [Boolean] Use the dash style variant.
      # @option kws timeout  [Integer] Auto-dismiss timeout in milliseconds.
      #   If nil, uses global configuration default. If false, no auto-dismiss.
      # @option kws autoclose [Boolean] Enable auto-dismiss using timeout.
      #   Must be true for auto-dismiss to work.
      # @option kws href     [String] Converts alert to a clickable link.
      # @option kws action   [String] Stimulus action to fire on click.
      # @option kws closable [Boolean] Show close button. Set to true to enable
      #   manual dismissal.
      #
      def initialize(*args, **kws, &block)
        super

        @icon = config_option(:icon)
        @timeout = config_option(:timeout)
        @autoclose = config_option(:autoclose)
        @closable = config_option(:closable, false)

        # `action:` (and its `data-action`) is handled by ActionableComponent,
        # pulled in via LinkableComponent. Emitting it here too would render a
        # duplicate `data-action` attribute.
      end

      def default_icon_size
        "where:size-6"
      end

      def before_render
        setup_component

        super
      end

      private

      # DaisyUI's `.alert` is a grid (`auto minmax(auto,1fr)` columns with a
      # 1rem gap) that already places the icon, so skip Iconable's root
      # classes — as utilities they beat the `.alert` styles in the cascade,
      # shrink-wrapping the alert to an inline-flex row, halving its gap, and
      # disabling the `alert-vertical` modifier.
      def iconable_root_css; end

      def setup_component
        add_css(:component, "alert")
        add_html(:component, { role: "alert" })

        setup_stimulus_controller
        setup_timeout
        setup_close_button
        setup_closable_padding
      end

      def setup_stimulus_controller
        return unless closable? || @autoclose

        add_stimulus_controller(:component, "loco-alert")
      end

      def setup_timeout
        timeout_value = if @timeout == false
                          nil
                        elsif @timeout.nil?
                          LocoMotion.configuration.default_alert_timeout
                        else
                          @timeout
                        end

        return unless timeout_value && @autoclose

        add_html(:component, {
                   "data-loco-alert-timeout-value": timeout_value
                 })
      end

      def setup_close_button
        return unless closable?

        set_tag_name(:close, :button)
        # Pin the close button to the alert's top-right corner so it is always
        # right-aligned and stays at the top of tall, multi-line alerts instead
        # of riding the vertical center of the `.alert` grid.
        add_css(:close, "btn btn-ghost btn-circle btn-xs where:absolute where:top-2 where:right-2")
        add_html(:close, { "data-action": "click->loco-alert#close" })
      end

      def setup_closable_padding
        return unless closable?

        # Reserve room for the absolutely-positioned close button so it never
        # overlaps the message. `where:relative` only establishes the positioning
        # context (nothing else sets `position` on `.alert`), but the padding is
        # functional and must beat DaisyUI's `.alert { padding-inline: 1rem }` —
        # so it is a plain (non-`where`) utility, not a zero-specificity
        # `:where()` rule the cascade would discard.
        add_css(:component, "where:relative pr-10")
      end
    end
  end
end
