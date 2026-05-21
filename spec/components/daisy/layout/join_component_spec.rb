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

      it "automatically adds join-item class to items" do
        expect(page).to have_selector(".join-item", count: 3)
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
        j.with_item { "Top" }
        j.with_item { "Middle" }
        j.with_item { "Bottom" }
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

  context "with custom CSS classes" do
    let(:join) { described_class.new }

    before do
      render_inline(join) do |j|
        j.with_item(css: "btn-primary") { "Primary" }
        j.with_item(css: "btn-secondary") { "Secondary" }
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

  context "with direct content (without with_item)" do
    let(:join) { described_class.new }

    before do
      render_inline(join) do
        "Direct content 1 Direct content 2 Direct content 3"
      end
    end

    describe "rendering" do
      it "has the join class" do
        expect(page).to have_selector(".join")
      end

      it "renders the direct content" do
        expect(page).to have_text("Direct content 1")
        expect(page).to have_text("Direct content 2")
        expect(page).to have_text("Direct content 3")
      end
    end
  end

  context "with radio buttons (with with_radio)" do
    let(:join) { described_class.new }

    before do
      render_inline(join) do |j|
        j.with_radio(name: "options", value: "1")
        j.with_radio(name: "options", value: "2")
        j.with_radio(name: "options", value: "3")
      end
    end

    describe "rendering" do
      it "has the join class" do
        expect(page).to have_selector(".join")
      end

      it "renders radio inputs" do
        expect(page).to have_selector("input[type='radio']", count: 3)
      end

      it "does not add radio class (skip_styling)" do
        expect(page).not_to have_selector("input.radio")
      end

      it "automatically adds join-item and btn classes" do
        expect(page).to have_selector("input.join-item.btn", count: 3)
      end
    end
  end

  context "with buttons (with with_button)" do
    let(:join) { described_class.new }

    before do
      render_inline(join) do |j|
        j.with_button(title: "Previous")
        j.with_button(title: "Current", css: "btn-active")
        j.with_button(title: "Next")
      end
    end

    describe "rendering" do
      it "has the join class" do
        expect(page).to have_selector(".join")
      end

      it "renders buttons" do
        expect(page).to have_selector("button.btn", count: 3)
      end

      it "automatically adds join-item class to buttons" do
        expect(page).to have_selector("button.join-item", count: 3)
      end

      it "preserves additional CSS classes" do
        expect(page).to have_selector("button.btn-active")
      end
    end
  end
end
