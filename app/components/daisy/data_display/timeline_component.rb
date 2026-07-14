# frozen_string_literal: true

module Daisy
  module DataDisplay
    #
    # The Timeline component displays a list of events in chronological order,
    # either vertically or horizontally. It's perfect for showing history,
    # progress, or any sequence of events that should be displayed in order.
    #
    # @slot event+ Individual events in the timeline. Each event can have
    #   leading, middle, and trailing sections.
    #
    # @loco_example Basic Vertical Timeline
    #   = daisy_timeline do |timeline|
    #     - timeline.with_event(leading: "2023", trailing: "Launched product") do |event|
    #       - event.with_middle { "🚀" }
    #
    #     - timeline.with_event(leading: "2024", trailing: "1M users") do |event|
    #       - event.with_middle { "🎉" }
    #
    # @loco_example Horizontal Timeline
    #   = daisy_timeline(css: "timeline-horizontal") do |timeline|
    #     - timeline.with_event(leading: "Q1", trailing: "Planning") do |event|
    #       - event.with_middle { "📋" }
    #
    #     - timeline.with_event(leading: "Q2", trailing: "Development") do |event|
    #       - event.with_middle { "💻" }
    #
    #     - timeline.with_event(leading: "Q3", trailing: "Testing") do |event|
    #       - event.with_middle { "🧪" }
    #
    #     - timeline.with_event(leading: "Q4", trailing: "Launch") do |event|
    #       - event.with_middle { "🚀" }
    #
    # @loco_example Custom Content (Vertical)
    #   = daisy_timeline do |timeline|
    #     - timeline.with_event do |event|
    #       - event.with_leading do
    #         .font-bold Jan 2024
    #         %div{ class: "text-sm text-base-content/70" } Q1
    #
    #       - event.with_middle do
    #         .bg-primary.text-primary-content.p-2.rounded-full
    #           = loco_icon("star")
    #
    #       - event.with_trailing do
    #         %h3.font-bold Milestone Reached
    #         %div{ class: "text-base-content/70" } Exceeded quarterly goals
    #
    class TimelineComponent < LocoMotion::BaseComponent
      renders_many :events, Daisy::DataDisplay::TimelineEventComponent

      def before_render
        set_tag_name(:component, :ul)
        add_css(:component, "timeline")
      end
    end
  end
end
