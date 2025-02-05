require "rails_helper"

RSpec.describe Daisy::Layout::StackComponent, type: :component do
  context "basic stack" do
    let(:stack) { described_class.new }

    before do
      render_inline(stack) do
        "Stack Content"
      end
    end

    describe "rendering" do
      it "has the stack class" do
        expect(page).to have_selector(".stack")
      end

      it "renders the content" do
        expect(page).to have_text("Stack Content")
      end
    end
  end

  context "with multiple stacked items" do
    let(:stack) { described_class.new }

    before do
      render_inline(stack) do
        safe_join([
          content_tag(:div, "Top Stack", class: "card"),
          content_tag(:div, "Middle Stack", class: "card"),
          content_tag(:div, "Bottom Stack", class: "card")
        ])
      end
    end

    describe "rendering" do
      it "renders all items" do
        expect(page).to have_selector(".card", count: 3)
      end

      it "renders items in order" do
        items = page.all(".card").map(&:text)
        expect(items).to eq(["Top Stack", "Middle Stack", "Bottom Stack"])
      end
    end
  end

  context "with custom styling" do
    let(:stack) { described_class.new(css: "bg-base-100/80") }

    before do
      render_inline(stack) do
        content_tag(:div, "Content", class: "card")
      end
    end

    describe "rendering" do
      it "applies custom CSS classes" do
        expect(page).to have_selector(".stack.bg-base-100\\/80")
      end
    end
  end
end
