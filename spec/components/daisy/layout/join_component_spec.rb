require "rails_helper"

RSpec.describe Daisy::Layout::JoinComponent, type: :component do
  context "basic join" do
    let(:join) { described_class.new }

    before do
      render_inline(join) do |j|
        j.with_item { "Item 1" }
        j.with_item { "Item 2" }
        j.with_item { "Item 3" }
      end
    end

    describe "rendering" do
      it "has the join class" do
        expect(page).to have_selector(".join")
      end

      it "renders all items" do
        expect(page).to have_text("Item 1")
        expect(page).to have_text("Item 2")
        expect(page).to have_text("Item 3")
      end
    end
  end

  context "without items" do
    let(:join) { described_class.new }

    before do
      render_inline(join)
    end

    describe "rendering" do
      it "renders an empty join container" do
        expect(page).to have_selector(".join")
      end
    end
  end

  context "with vertical orientation" do
    let(:join) { described_class.new(css: "join-vertical") }

    before do
      render_inline(join) do |j|
        j.with_item(css: "join-item") { "Top" }
        j.with_item(css: "join-item") { "Middle" }
        j.with_item(css: "join-item") { "Bottom" }
      end
    end

    describe "rendering" do
      it "includes the vertical class" do
        expect(page).to have_selector(".join.join-vertical")
      end

      it "renders all items" do
        expect(page).to have_selector(".join-item", count: 3)
      end

      it "renders items in order" do
        items = page.all(".join-item").map(&:text)
        expect(items).to eq(["Top", "Middle", "Bottom"])
      end
    end
  end

  context "with join items" do
    let(:join) { described_class.new }

    before do
      render_inline(join) do |j|
        j.with_item(css: "join-item btn-primary") { "Primary" }
        j.with_item(css: "join-item btn-secondary") { "Secondary" }
      end
    end

    describe "rendering" do
      it "applies additional CSS classes to items" do
        expect(page).to have_selector(".join-item.btn-primary")
        expect(page).to have_selector(".join-item.btn-secondary")
      end

      it "renders the content" do
        expect(page).to have_text("Primary")
        expect(page).to have_text("Secondary")
      end
    end
  end
end
