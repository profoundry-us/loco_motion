require "rails_helper"

RSpec.describe Daisy::DataDisplay::TimelineComponent, type: :component do
  it "renders a basic timeline" do
    render_inline(described_class.new) do |timeline|
      timeline.with_event(start: "1985", middle_icon: "user-circle", end: "Topher Born")
      timeline.with_event(start: "College", middle_icon: "academic-cap", end: "2006")
    end

    expect(page).to have_css("ul.timeline")
    expect(page).to have_css("li", count: 2)
    expect(page).to have_css(".timeline-start", text: "1985")
    expect(page).to have_css(".timeline-start", text: "College")
    expect(page).to have_css(".timeline-end", text: "Topher Born")
    expect(page).to have_css(".timeline-end", text: "2006")
    expect(page).to have_css("svg", count: 2)  # For the middle icons
  end

  it "renders a timeline with custom blocks" do
    render_inline(described_class.new) do |timeline|
      timeline.with_event do |event|
        event.with_start(css: "font-bold") { "1985" }
        event.with_middle { tag.svg }
        event.with_end(css: "timeline-box") { "Born" }
      end
    end

    expect(page).to have_css(".timeline-start.font-bold", text: "1985")
    expect(page).to have_css(".timeline-middle svg")
    expect(page).to have_css(".timeline-end.timeline-box", text: "Born")
  end

  it "renders a timeline with simple content" do
    render_inline(described_class.new) do |timeline|
      timeline.with_event(
        start: "Start",
        middle_icon: "check-circle",
        end: "End"
      )
    end

    expect(page).to have_css(".timeline-start", text: "Start")
    expect(page).to have_css(".timeline-middle svg")  # Icon is rendered as SVG
    expect(page).to have_css(".timeline-end", text: "End")
  end

  it "handles middle and middle_icon being mutually exclusive" do
    render_inline(described_class.new) do |timeline|
      timeline.with_event do |event|
        event.with_middle { "Custom Middle" }
      end

      timeline.with_event(middle_icon: "check-circle")
    end

    expect(page).to have_css(".timeline-middle", text: "Custom Middle")
    expect(page).to have_css(".timeline-middle svg")  # Icon is rendered as SVG
  end

  it "renders a timeline with multiple events and separators" do
    render_inline(described_class.new) do |timeline|
      3.times do |i|
        timeline.with_event(start: "Event #{i}")
      end
    end

    expect(page).to have_css("li", count: 3)
    expect(page).to have_css("hr")  # Separator between events
    expect(page).to have_css(".timeline-start", text: "Event 0")
    expect(page).to have_css(".timeline-start", text: "Event 1")
    expect(page).to have_css(".timeline-start", text: "Event 2")
  end

  it "allows customization of event parts" do
    render_inline(described_class.new) do |timeline|
      timeline.with_event do |event|
        event.with_start(css: "custom-start") { "Start" }
        event.with_middle(css: "custom-middle") { "Middle" }
        event.with_end(css: "custom-end") { "End" }
      end
    end

    expect(page).to have_css(".timeline-start.custom-start", text: "Start")
    expect(page).to have_css(".timeline-middle.custom-middle", text: "Middle")
    expect(page).to have_css(".timeline-end.custom-end", text: "End")
  end
end
