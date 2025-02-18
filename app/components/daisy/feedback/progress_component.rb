#
# The ProgressComponent displays a horizontal bar that indicates the completion
# status of a process. It can show determinate progress with a specific value
# or indeterminate progress with an animated bar.
#
# The component renders as an HTML `<progress>` element and supports various
# colors and styles through CSS classes.
#
# @loco_example Basic Progress Bars
#   = daisy_progress(value: 25)
#   = daisy_progress(css: "progress-primary", value: 50)
#   = daisy_progress(css: "progress-secondary", value: 75)
#   = daisy_progress(css: "progress-accent", value: 100)
#
# @loco_example Indeterminate Progress Bars
#   = daisy_progress(css: "progress-info")
#   = daisy_progress(css: "progress-success ![animation-delay:250ms]")
#   = daisy_progress(css: "progress-warning ![animation-delay:500ms]")
#   = daisy_progress(css: "progress-error ![animation-delay:750ms]")
#
class Daisy::Feedback::ProgressComponent < LocoMotion::BaseComponent

  #
  # Creates a new Progress component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the progress bar.
  #
  # @option kws value [Integer, nil] The current progress value. Set to `nil`
  #   for an indeterminate progress bar that animates continuously. Defaults
  #   to `nil`.
  #
  # @option kws max   [Integer] The maximum value for the progress bar.
  #   Defaults to `100` to easily work with percentage values.
  #
  # @option kws css   [String] Additional CSS classes for the progress bar.
  #   Available styles include: `progress-primary`, `progress-secondary`,
  #   `progress-accent`, `progress-info`, `progress-success`,
  #   `progress-warning`, and `progress-error`. Can be combined with utility
  #   classes like `![animation-delay:250ms]` for staggered animations.
  #
  def initialize(*args, **kws, &block)
    super

    @value = config_option(:value, nil)
    @max = config_option(:max, 100)
  end

  def before_render
    set_tag_name(:component, :progress)
    add_css(:component, "progress")
    add_html(:component, { value: @value, max: @max }) if @value != nil
  end

  def call
    part(:component)
  end
end
