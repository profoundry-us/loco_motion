require "rails_helper"

RSpec.describe Daisy::Layout::DividerComponent, type: :component do
  context "basic divider" do
    let(:divider) { described_class.new }

    before do
      render_inline(divider)
    end

    describe "rendering" do
      it "has the divider class" do
        expect(page).to have_selector(".divider")
      end
    end
  end

  context "with text" do
    let(:divider) { described_class.new }

    before do
      render_inline(divider) do
        "Divider Text"
      end
    end

    describe "rendering" do
      it "renders the text content" do
        expect(page).to have_selector(".divider", text: "Divider Text")
      end
    end
  end

  context "with additional CSS classes" do
    let(:divider) { described_class.new(css: "divider-horizontal divider-accent") }

    before do
      render_inline(divider) do
        "Accent Divider"
      end
    end

    describe "rendering" do
      it "includes the additional CSS classes" do
        expect(page).to have_selector(".divider.divider-horizontal.divider-accent")
      end

      it "renders the text content" do
        expect(page).to have_text("Accent Divider")
      end
    end
  end
end
