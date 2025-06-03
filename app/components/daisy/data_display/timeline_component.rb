#
# The Timeline component displays a list of events in chronological order,
# either vertically or horizontally. It's perfect for showing history,
# progress, or any sequence of events that should be displayed in order.
#
# @slot event+ Individual events in the timeline. Each event can have start,
#   middle, and end sections.
#
# @loco_example Basic Vertical Timeline
#   = daisy_timeline do |timeline|
#     - timeline.with_event(start: "2023", end: "Launched product") do |event|
#       - event.with_middle { "🚀" }
#
#     - timeline.with_event(start: "2024", end: "1M users") do |event|
#       - event.with_middle { "🎉" }
#
# @loco_example Horizontal Timeline
#   = daisy_timeline(css: "timeline-horizontal") do |timeline|
#     - timeline.with_event(start: "Q1", end: "Planning") do |event|
#       - event.with_middle { "📋" }
#
#     - timeline.with_event(start: "Q2", end: "Development") do |event|
#       - event.with_middle { "💻" }
#
#     - timeline.with_event(start: "Q3", end: "Testing") do |event|
#       - event.with_middle { "🧪" }
#
#     - timeline.with_event(start: "Q4", end: "Launch") do |event|
#       - event.with_middle { "🚀" }
#
# @loco_example Custom Content (Vertical)
#   = daisy_timeline do |timeline|
#     - timeline.with_event do |event|
#       - event.with_start do
#         .font-bold Jan 2024
#         %div{ class: "text-sm text-base-content/70" } Q1
#
#       - event.with_middle do
#         .bg-primary.text-primary-content.p-2.rounded-full
#           = heroicon "star"
#
#       - event.with_end do
#         %h3.font-bold Milestone Reached
#         %div{ class: "text-base-content/70" } Exceeded quarterly goals
#
class Daisy::DataDisplay::TimelineComponent < LocoMotion::BaseComponent
  renders_many :events, Daisy::DataDisplay::TimelineEventComponent

  def before_render
    set_tag_name(:component, :ul)
    add_css(:component, "timeline")
  end
end
