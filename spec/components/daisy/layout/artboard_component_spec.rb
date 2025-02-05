require "rails_helper"

RSpec.describe Daisy::Layout::ArtboardComponent, type: :component do
  context "basic artboard" do
    let(:artboard) { described_class.new }

    before do
      render_inline(artboard) do
        "Artboard Content"
      end
    end

    describe "rendering" do
      it "has the artboard class" do
        expect(page).to have_selector(".artboard")
      end

      it "renders the content" do
        expect(page).to have_text("Artboard Content")
      end
    end
  end
end
