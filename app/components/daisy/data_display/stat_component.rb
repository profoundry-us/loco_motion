#
# The Stat component displays a statistic or metric with optional title,
# description, and figure. It's perfect for dashboards, summaries, or any
# situation where you need to highlight important numbers or metrics.
#
# @note Stats have a transparent background by default. Use `bg-base-100` if you
#   need a background color.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @part title The title section above the value.
# @part value The main value or metric being displayed.
# @part description Additional text below the value.
# @part figure An optional figure (usually an icon or small image) to display.
#
# @slot title Custom content for the title section. You can also provide a
#   simple title string via the title option.
#
# @slot description Custom content for the description section. You can also
#   provide a simple description string via the description option.
#
# @slot figure Custom content for the figure section. You can also provide an
#   image via the src option or an icon via the icon option.
#
# @loco_example Basic Usage
#   = daisy_stat(title: "Downloads", value: "31K")
#
# @loco_example With Description
#   = daisy_stat(title: "New Users", value: "2.6K", description: "↗︎ 400 (22%)")
#
# @loco_example With Icon
#   = daisy_stat(title: "Page Views", value: "89,400", icon: "eye") do |stat|
#     = stat.with_description do
#       .flex.items-center.gap-1
#         = heroicon_tag "arrow-up", class: "size-4 text-success"
#         %span.text-success 14%
#         from last month
#
# @loco_example With Custom Figure
#   = daisy_stat(title: "Success Rate", value: "98%") do |stat|
#     = stat.with_figure do
#       .text-success
#         = heroicon_tag "check-circle", class: "size-10"
#
class Daisy::DataDisplay::StatComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::IconableComponent
  include LocoMotion::Concerns::LinkableComponent
  include LocoMotion::Concerns::TippableComponent

  set_component_name :stat

  define_parts :title, :value, :description, :figure

  renders_one :title
  renders_one :description
  renders_one :figure

  # @return [String] The title text when using the simple title option.
  attr_reader :simple_title

  # @return [String] The description text when using the simple description
  #   option.
  attr_reader :simple_description

  #
  # Creates a new stat component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws [String] :title The text to display in the title section.
  #   You can also provide custom title content using the title slot.
  #
  # @option kws [String] :description The text to display in the description
  #   section. You can also provide custom description content using the
  #   description slot.
  #
  # @option kws [String] :src URL of an image to display in the figure
  #   section.
  #
  # @option kws [String] :icon Name of a heroicon to display in the figure
  #   section.
  #
  # @option kws [String] :tip The tooltip text to display when hovering over
  #   the component.
  #
  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title)
    @simple_description = config_option(:description)
    @src = config_option(:src)
  end

  def before_render
    setup_component

    super
  end

  def default_icon_size
    "where:size-8"
  end

  private

  def setup_component
    add_css(:component, "stat")
    add_css(:title, "stat-title")
    add_css(:value, "stat-value")
    add_css(:description, "stat-desc")
    add_css(:figure, "stat-figure")
  end
end
