# frozen_string_literal: true

module Daisy
  module DataDisplay
    #
    # The Stat component displays a statistic or metric with optional title,
    # description, and figure. It's perfect for dashboards, summaries, or any
    # situation where you need to highlight important numbers or metrics.
    #
    # Includes the {LocoMotion::Concerns::TippableComponent} module to
    # enable easy tooltip addition.
    #
    # @note Stats have a transparent background by default. Use
    #   `bg-base-100` if you need a background color.
    #
    # @note `right_icon` and its `right_icon_*` variants have no effect on
    #   Stat — the template only ever renders the left/aliased icon via
    #   `render_icon` inside the figure part.
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
    #   = daisy_stat(title: "Downloads") do
    #     31K
    #
    # @loco_example With Description
    #   = daisy_stat(title: "New Users", description: "↗︎ 400 (22%)") do
    #     2.6K
    #
    # @loco_example With Icon
    #   = daisy_stat(title: "Page Views", icon: "eye") do |stat|
    #     89,400
    #     - stat.with_description do
    #       .flex.items-center.gap-1
    #         = loco_icon("arrow-up", css: "size-4 text-success")
    #         %span.text-success 14%
    #         from last month
    #
    # @loco_example With Custom Figure
    #   = daisy_stat(title: "Success Rate") do |stat|
    #     98%
    #     - stat.with_figure do
    #       .text-success
    #         = loco_icon("check-circle", css: "size-10")
    #
    class StatComponent < LocoMotion::BaseComponent
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
      #   When `href` is also set, this same text becomes the anchor's
      #   `title` HTML attribute (via
      #   {LocoMotion::Concerns::LinkableComponent}) in addition to the
      #   visible stat title.
      #
      # @option kws [String] :description The text to display in the description
      #   section. You can also provide custom description content using the
      #   description slot.
      #
      # @option kws [String] :src URL of an image to display in the figure
      #   section.
      #
      # @option kws [String] :icon Name of an icon to display in the figure
      #   section.
      #
      # @option kws [String] :icon_css The CSS classes to apply to the icon.
      #
      # @option kws [Hash] :icon_html Additional HTML attributes to apply to
      #   the icon.
      #
      # @option kws [Hash] :icon_options Additional keyword arguments
      #   forwarded to the icon component (e.g. `tip:`).
      #
      # @option kws [String] :href A path or URL to which the user will be
      #   directed when the stat is clicked. Forces the Stat to use an `<a>`
      #   tag.
      #
      # @option kws [String] :target The HTML `target` attribute for the
      #   `<a>` tag (`_blank`, `_parent`, or a specific tab / window /
      #   iframe, etc).
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

      # The stat renders its icon inside the figure part, so skip Iconable's
      # root `where:inline-flex` classes — they override DaisyUI's `.stat`
      # grid (utilities beat component styles in the cascade layers) and
      # flatten the title / value / description onto a single line.
      def iconable_root_css; end

      def setup_component
        add_css(:component, "stat")
        add_css(:title, "stat-title")
        add_css(:value, "stat-value")
        add_css(:description, "stat-desc")
        add_css(:figure, "stat-figure")
      end
    end
  end
end
