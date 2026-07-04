# frozen_string_literal: true

#
# A component for rendering individual events within a timeline. Each event can
# have three sections: leading (typically a date or time), middle (an icon or
# marker), and trailing (the event description).
#
# @part leading The container for the leading content (e.g., date/time).
# @part middle The container for the middle content.
# @part middle_icon Container for a simple icon when not using custom middle
#   content.
# @part trailing The container for the trailing content (e.g., description).
# @part separator The line connecting this event to the next one.
#
# @slot leading Custom content for the leading section. You can also provide
#   simple text via the leading option.
#
# @slot middle Custom content for the middle section. You can also provide
#   simple text via the middle option, or an icon via the middle_icon option.
#
# @slot trailing Custom content for the trailing section. You can also provide
#   simple text via the trailing option.
#
# @note The middle and middle_icon options are mutually exclusive. If both are
#   provided, middle takes precedence.
#
# @loco_example Simple Event
#   = daisy_timeline do |timeline|
#     - timeline.with_event(leading: "2023", middle: "🚀", trailing: "Launched product")
#     - timeline.with_event(leading: "2024", middle: "🎉", trailing: "1M users")
#
# @loco_example Event with Custom Content
#   = daisy_timeline do |timeline|
#     - timeline.with_event do |event|
#       - event.with_leading do
#         .font-bold Jan 2024
#       - event.with_middle do
#         = loco_icon("star")
#       - event.with_trailing do
#         %h3.font-bold Milestone Reached
#
module Daisy
  module DataDisplay
    class TimelineEventComponent < LocoMotion::BaseComponent
      renders_one :leading, LocoMotion::BasicComponent.build(css: "timeline-start")
      renders_one :middle, LocoMotion::BasicComponent.build(css: "timeline-middle")
      renders_one :trailing, LocoMotion::BasicComponent.build(css: "timeline-end")

      define_parts :leading, :middle, :middle_icon, :trailing, :separator

      #
      # Creates a new timeline event component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws [String] :leading Text to display in the leading section.
      #   You can also provide custom content using the leading slot.
      #
      # @option kws [String] :middle Text to display in the middle section. You
      #   can also provide custom content using the middle slot.
      #
      # @option kws [String] :middle_icon Name of an icon to display in the
      #   middle section. Ignored if middle is provided.
      #
      # @option kws [String] :trailing Text to display in the trailing section.
      #   You can also provide custom content using the trailing slot.
      #
      def initialize(*args, **kws, &block)
        super(*args, **kws, &block)

        @event_index = nil
        @events_length = nil

        @simple_leading = config_option(:leading)
        @simple_middle = config_option(:middle)
        @simple_middle_icon = config_option(:middle_icon)
        @simple_trailing = config_option(:trailing)
      end

      def before_render
        set_tag_name(:component, :li)

        setup_parts
        setup_separator

        super
      end

      def setup_parts
        add_css(:leading, "timeline-start")
        add_css(:middle, "timeline-middle")
        add_css(:trailing, "timeline-end")
      end

      def setup_separator
        set_tag_name(:separator, :hr)
      end

      # rubocop:disable Naming/AccessorMethodName
      def set_event_index(index)
        @event_index = index
      end

      def set_events_length(length)
        @events_length = length
      end
      # rubocop:enable Naming/AccessorMethodName
    end
  end
end
