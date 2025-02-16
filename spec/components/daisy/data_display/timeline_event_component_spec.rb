require "rails_helper"

RSpec.describe Daisy::DataDisplay::TimelineEventComponent, type: :component do
  context "basic timeline event" do
    let(:event) { described_class.new }

    before do
      render_inline(event)
    end

    describe "rendering" do
      it "renders as a list item" do
        expect(page).to have_selector("li")
      end
    end
  end

  context "with simple parts" do
    let(:event) { described_class.new(start: "Start", middle: "Middle", end: "End") }

    before do
      render_inline(event)
    end

    describe "rendering" do
      it "renders the start content" do
        expect(page).to have_selector(".timeline-start", text: "Start")
      end

      it "renders the middle content" do
        expect(page).to have_selector(".timeline-middle", text: "Middle")
      end

      it "renders the end content" do
        expect(page).to have_selector(".timeline-end", text: "End")
      end
    end
  end

  context "with block parts" do
    let(:event) { described_class.new }

    before do
      render_inline(event) do |e|
        e.with_start { "Block Start" }
        e.with_middle { "Block Middle" }
        e.with_end { "Block End" }
      end
    end

    describe "rendering" do
      it "renders the start content" do
        expect(page).to have_selector(".timeline-start", text: "Block Start")
      end

      it "renders the middle content" do
        expect(page).to have_selector(".timeline-middle", text: "Block Middle")
      end

      it "renders the end content" do
        expect(page).to have_selector(".timeline-end", text: "Block End")
      end
    end
  end

  context "with middle icon" do
    let(:event) { described_class.new(middle_icon: "star") }

    before do
      render_inline(event)
    end

    describe "rendering" do
      it "renders the middle icon" do
        expect(page).to have_selector(".timeline-middle")
      end
    end
  end

  context "with middle content taking precedence over icon" do
    let(:event) { described_class.new(middle: "Middle Content", middle_icon: "star") }

    before do
      render_inline(event)
    end

    describe "rendering" do
      it "renders the middle content instead of the icon" do
        expect(page).to have_selector(".timeline-middle", text: "Middle Content")
      end
    end
  end

  context "with event index and length" do
    let(:event) { described_class.new }

    before do
      event.set_event_index(1)
      event.set_events_length(3)
      render_inline(event)
    end

    describe "rendering" do
      it "renders as a list item" do
        expect(page).to have_selector("li")
      end

      it "renders the separator" do
        expect(page).to have_selector("hr")
      end
    end
  end
end
