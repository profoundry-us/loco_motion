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
          tag.input(class: "input", placeholder: "https://example.com")
        end

        "Content"
      end
    end

    describe "rendering" do
      it "renders the toolbar" do
        expect(page).to have_selector(".mockup-browser-toolbar")
      end

      it "renders the toolbar content" do
        expect(page).to have_selector("input[placeholder='https://example.com']")
      end

      it "renders the main content" do
        expect(page).to have_text("Content")
      end
    end
  end

  context "with custom styling" do
    let(:browser) { described_class.new(css: "bg-sky-400 border border-sky-600") }

    before do
      render_inline(browser) do
        "Content"
      end
    end

    describe "rendering" do
      it "applies custom CSS classes" do
        expect(page).to have_selector(".mockup-browser.bg-sky-400.border.border-sky-600")
      end
    end
  end
end
