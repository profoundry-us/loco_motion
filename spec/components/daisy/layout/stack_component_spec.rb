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
end
