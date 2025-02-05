require "rails_helper"

RSpec.describe Daisy::Layout::HeroComponent, type: :component do
  context "basic hero" do
    let(:hero) { described_class.new }

    before do
      render_inline(hero) do
        "Hero Content"
      end
    end

    describe "rendering" do
      it "has the hero class" do
        expect(page).to have_selector(".hero")
      end

      it "has the hero-content wrapper" do
        expect(page).to have_selector(".hero-content")
      end

      it "renders the content" do
        expect(page).to have_selector(".hero-content", text: "Hero Content")
      end
    end
  end

  context "with overlay" do
    let(:hero) { described_class.new }

    before do
      render_inline(hero) do |h|
        h.with_overlay do
          "Overlay Content"
        end

        "Hero Content"
      end
    end

    describe "rendering" do
      it "renders the overlay" do
        expect(page).to have_selector(".hero-overlay", text: "Overlay Content")
      end

      it "renders the main content" do
        expect(page).to have_selector(".hero-content", text: "Hero Content")
      end
    end
  end
end
