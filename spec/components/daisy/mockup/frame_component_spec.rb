require "rails_helper"

RSpec.describe Daisy::Mockup::FrameComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  shared_examples "a frame component" do
    it "has the mockup-window class" do
      expect(page).to have_selector(".mockup-window")
    end

    it "renders the content when provided" do
      expect(page).to have_text(content_text) if defined?(content_text)
    end
  end

  context "basic frame" do
    let(:content_text) { "Frame Content" }
    let(:frame) { described_class.new(css: "w-full max-w-4xl border border-base-300") }

    before do
      render_inline(frame) do
        tag.div(content_text, class: "border-t border-base-300 px-4 py-16 text-center")
      end
    end

    describe "rendering" do
      include_examples "a frame component"

      it "renders with base border" do
        expect(page).to have_selector(".border-base-300")
      end

      it "applies max width" do
        expect(page).to have_selector(".max-w-4xl")
      end
    end
  end

  context "without content" do
    let(:frame) { described_class.new }

    before do
      render_inline(frame)
    end

    describe "rendering" do
      include_examples "a frame component"

      it "renders an empty frame" do
        expect(page).to have_selector(".mockup-window:empty")
      end
    end
  end

  context "with HTML content" do
    describe "rendering" do
      before do
        @output_buffer = ActionView::OutputBuffer.new
      end

      let(:content_text) { "Click Me" }
      let(:content) do
        content_tag(:div, class: "mt-4") do
          content_tag(:button, content_text, class: "btn btn-primary")
        end
      end

      before do
        render_inline(described_class.new) { content }
      end

      it_behaves_like "a frame component"

      it "renders nested HTML elements" do
        expect(page).to have_selector("button.btn.btn-primary", text: content_text)
      end
    end
  end

  context "styled frame" do
    let(:content_text) { "Styled Content" }
    let(:frame) { described_class.new(css: "w-full max-w-4xl bg-purple-200 border border-purple-600") }

    before do
      render_inline(frame) do
        tag.div(content_text, class: "bg-base-100 border-t border-purple-300 px-4 py-16 text-center")
      end
    end

    describe "rendering" do
      include_examples "a frame component"

      it "applies custom background color" do
        expect(page).to have_selector(".bg-purple-200")
      end

      it "applies custom border color" do
        expect(page).to have_selector(".border-purple-600")
      end

      it "applies content border color" do
        expect(page).to have_selector(".border-purple-300")
      end
    end
  end

  context "with responsive design" do
    let(:frame) { described_class.new(css: "w-full md:w-3/4 lg:w-1/2") }
    let(:content_text) { "Responsive Content" }

    before do
      render_inline(frame) do
        content_text
      end
    end

    describe "rendering" do
      include_examples "a frame component"

      it "applies responsive width classes" do
        expect(page).to have_selector(".w-full.md\\:w-3\\/4.lg\\:w-1\\/2")
      end
    end
  end

  context "with border radius" do
    let(:frame) { described_class.new(css: "rounded-xl") }
    let(:content_text) { "Rounded Content" }

    before do
      render_inline(frame) do
        content_text
      end
    end

    describe "rendering" do
      include_examples "a frame component"

      it "applies border radius" do
        expect(page).to have_selector(".rounded-xl")
      end
    end
  end

  context "with nested components" do
    describe "rendering" do
      let(:stat) { Daisy::DataDisplay::StatComponent.new(title: "Downloads") }
      let(:frame) { described_class.new }
      let(:rendered) do
        render_inline(frame) do
          content_tag(:div, class: "stats shadow") do
            frame.daisy_stat(title: "Downloads") { "31K" }
          end
        end
      end

      before do
        rendered
      end

      it "renders nested components" do
        expect(page).to have_selector(".stats")
        expect(page).to have_selector(".stat")
        expect(page).to have_selector(".stat-value", text: "31K")
      end
    end
  end
end
