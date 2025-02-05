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

  context "with positioned items" do
    let(:indicator) { described_class.new }
    let(:positions) do
      {
        vertical: ["indicator-top", "indicator-middle", "indicator-bottom"],
        horizontal: ["indicator-start", "indicator-center", "indicator-end"]
      }
    end

    before do
      render_inline(indicator) do |i|
        positions[:vertical].each do |v|
          positions[:horizontal].each do |h|
            i.with_item(css: "#{v} #{h}") { "#{v} #{h}" }
          end
        end

        "Content"
      end
    end

    describe "rendering" do
      it "renders items with correct positions" do
        positions[:vertical].each do |v|
          positions[:horizontal].each do |h|
            expect(page).to have_selector(".indicator-item.#{v}.#{h}")
          end
        end
      end

      it "renders all items" do
        total_positions = positions[:vertical].length * positions[:horizontal].length
        expect(page).to have_selector(".indicator-item", count: total_positions)
      end

      it "renders the content" do
        expect(page).to have_text("Content")
      end
    end
  end
end
