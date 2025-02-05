require "rails_helper"

RSpec.describe Daisy::Layout::IndicatorComponent, type: :component do
  context "basic indicator" do
    let(:indicator) { described_class.new }

    before do
      render_inline(indicator) do |i|
        i.with_item do
          "Indicator Item"
        end

        "Main Content"
      end
    end

    describe "rendering" do
      it "has the indicator class" do
        expect(page).to have_selector(".indicator")
      end

      it "renders the indicator item" do
        expect(page).to have_selector(".indicator-item", text: "Indicator Item")
      end

      it "renders the main content" do
        expect(page).to have_text("Main Content")
      end
    end
  end

  context "with multiple items" do
    let(:indicator) { described_class.new }

    before do
      render_inline(indicator) do |i|
        i.with_item { "Item 1" }
        i.with_item { "Item 2" }
        i.with_item { "Item 3" }

        "Main Content"
      end
    end

    describe "rendering" do
      it "renders all indicator items" do
        expect(page).to have_selector(".indicator-item", count: 3)
        expect(page).to have_selector(".indicator-item", text: "Item 1")
        expect(page).to have_selector(".indicator-item", text: "Item 2")
        expect(page).to have_selector(".indicator-item", text: "Item 3")
      end

      it "renders the main content" do
        expect(page).to have_text("Main Content")
      end
    end
  end

  context "without content" do
    let(:indicator) { described_class.new }

    before do
      render_inline(indicator) do |i|
        i.with_item { "Solo Item" }
      end
    end

    describe "rendering" do
      it "renders only the indicator items" do
        expect(page).to have_selector(".indicator-item", text: "Solo Item")
      end
    end
  end
end
