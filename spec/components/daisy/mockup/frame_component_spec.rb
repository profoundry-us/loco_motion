require "rails_helper"

RSpec.describe Daisy::Mockup::FrameComponent, type: :component do
  context "basic frame" do
    let(:frame) { described_class.new }

    before do
      render_inline(frame) do
        "Window Content"
      end
    end

    describe "rendering" do
      it "has the mockup-window class" do
        expect(page).to have_selector(".mockup-window")
      end

      it "renders the content" do
        expect(page).to have_text("Window Content")
      end
    end
  end
end
