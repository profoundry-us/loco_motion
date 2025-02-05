require "rails_helper"

RSpec.describe Daisy::Mockup::BrowserComponent, type: :component do
  context "basic browser" do
    let(:browser) { described_class.new }

    before do
      render_inline(browser) do
        "Content"
      end
    end

    describe "rendering" do
      it "has the mockup-browser class" do
        expect(page).to have_selector(".mockup-browser")
      end

      it "renders the content" do
        expect(page).to have_text("Content")
      end
    end
  end

  context "with toolbar" do
    let(:browser) { described_class.new }

    before do
      render_inline(browser) do |b|
        b.with_toolbar do
          "Toolbar Content"
        end

        "Browser Content"
      end
    end

    describe "rendering" do
      it "renders the toolbar" do
        expect(page).to have_selector(".mockup-browser-toolbar", text: "Toolbar Content")
      end

      it "renders the content" do
        expect(page).to have_text("Browser Content")
      end
    end
  end
end
