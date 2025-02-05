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

  context "with custom content wrapper CSS" do
    let(:hero) { described_class.new(content_wrapper_css: "flex-col md:flex-row") }

    before do
      render_inline(hero) do
        "Hero Content"
      end
    end

    describe "rendering" do
      it "applies the custom CSS to the content wrapper" do
        expect(page).to have_selector(".hero-content.flex-col.md\\:flex-row")
      end

      it "renders the content" do
        expect(page).to have_selector(".hero-content", text: "Hero Content")
      end
    end
  end

  context "with background color" do
    let(:hero) { described_class.new(css: "bg-base-200") }

    before do
      render_inline(hero) do
        "Hero Content"
      end
    end

    describe "rendering" do
      it "applies the background color class" do
        expect(page).to have_selector(".hero.bg-base-200")
      end
    end
  end
end
