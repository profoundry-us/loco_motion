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
#   = daisy_alert(icon: "information-circle", css: "alert-info", icon_html: { variant: :outline }) do
#     This alert can be closed manually.
#
# @loco_example Auto-dismissing Alert
#   = daisy_alert(icon: "check-circle", css: "alert-success", autoclose: true, timeout: 3000, icon_html: { variant: :outline }) do
#     This alert will auto-dismiss in 3 seconds.
#
# @loco_example Clickable Link Alert
#   = daisy_alert(icon: "information-circle", css: "alert-info", href: "/docs", icon_html: { variant: :outline }) do
#     Click to view documentation.
#
# @loco_example Stimulus Action Alert
#   = daisy_alert(icon: "exclamation-triangle", css: "alert-warning", action: "click->my-controller#handle", icon_html: { variant: :outline }) do
#     Click to trigger custom action.
#
class Daisy::Feedback::AlertComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::IconableComponent
  include LocoMotion::Concerns::LinkableComponent

  define_parts :icon, :content_wrapper, :close

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
    @action = config_option(:action)
    @closable = config_option(:closable)
  end

  def default_icon_size
    "where:size-6"
  end

  def before_render
    # Call super first to run concern setups (LinkableComponent)
    super

    add_css(:component, "alert where:relative")
    add_html(:component, { role: "alert" })

    setup_stimulus_controller
    setup_timeout
    setup_action
    setup_closable
    setup_close_button
    setup_closable_padding
  end

  private

  def setup_stimulus_controller
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

    # Only add data-timeout if autoclose is true
    if timeout_value && @autoclose
      add_html(:component, { "data-timeout": timeout_value })
    end
  end

  def setup_action
    if @action
      add_html(:component, { "data-action": @action })
    end
  end

  def setup_closable
    # Default to not closable unless explicitly set to true
    should_be_closable = if @closable.nil?
      false
    else
      @closable
    end

    @closable = should_be_closable
  end

  def closable?
    @closable
  end

  def setup_close_button
    return unless closable?

    set_tag_name(:close, :button)
    add_css(:close, "btn btn-link btn-xs where:absolute where:top-3 where:right-2")
    add_html(:close, { "data-action": "click->loco-alert#close" })
  end

  def setup_closable_padding
    return unless closable?

    add_css(:component, "where:pr-10")
  end
end
