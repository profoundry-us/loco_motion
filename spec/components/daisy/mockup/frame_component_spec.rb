require "rails_helper"

RSpec.describe Daisy::Mockup::FrameComponent, type: :component do
  context "basic frame" do
    let(:frame) { described_class.new(css: "w-full max-w-4xl border border-base-300") }

    before do
      render_inline(frame) do
        tag.div("Frame Content", class: "border-t border-base-300 px-4 py-16 text-center")
      end
    end

    describe "rendering" do
      it "has the mockup-window class" do
        expect(page).to have_selector(".mockup-window")
      end

      it "renders with base border" do
        expect(page).to have_selector(".border-base-300")
      end

      it "renders the content" do
        expect(page).to have_text("Frame Content")
      end
    end
  end

  context "styled frame" do
    let(:frame) { described_class.new(css: "w-full max-w-4xl bg-purple-200 border border-purple-600") }

    before do
      render_inline(frame) do
        tag.div("Styled Content", class: "bg-base-100 border-t border-purple-300 px-4 py-16 text-center")
      end
    end

    describe "rendering" do
      it "applies custom background color" do
        expect(page).to have_selector(".bg-purple-200")
      end

      it "applies custom border color" do
        expect(page).to have_selector(".border-purple-600")
      end

      it "renders the content" do
        expect(page).to have_text("Styled Content")
      end

      it "applies content border color" do
        expect(page).to have_selector(".border-purple-300")
      end
    end
  end

  context "with custom width" do
    let(:frame) { described_class.new(css: "w-96") }

    before do
      render_inline(frame) do
        "Custom Width"
      end
    end

    describe "rendering" do
      it "applies custom width class" do
        expect(page).to have_selector(".w-96")
      end
    end
  end
end
