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
end
