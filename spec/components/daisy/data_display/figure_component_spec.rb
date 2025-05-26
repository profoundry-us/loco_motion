require "rails_helper"

RSpec.describe Daisy::DataDisplay::FigureComponent, type: :component do
  context "basic rendering" do
    let(:figure) { described_class.new }

    it "renders a figure tag" do
      render_inline(figure)
      expect(page).to have_selector("figure")
    end
  end

  context "with src" do
    let(:figure) { described_class.new(src: "example.jpg") }

    before do
      render_inline(figure)
    end

    it "renders an img tag" do
      expect(page).to have_selector("figure img")
    end

    it "sets the src attribute" do
      expect(page).to have_selector("img[src='example.jpg']")
    end
  end

  context "with content" do
    let(:figure) { described_class.new }

    before do
      render_inline(figure) { "Custom content" }
    end

    it "renders the content" do
      expect(page).to have_selector("figure", text: "Custom content")
    end
  end

  context "with custom CSS" do
    let(:figure) { described_class.new(css: "custom-class") }

    before do
      render_inline(figure)
    end

    it "includes the custom class" do
      expect(page).to have_selector("figure.custom-class")
    end
  end

  context "with both src and content" do
    let(:figure) { described_class.new(src: "example.jpg") }

    before do
      render_inline(figure) { "Figure caption" }
    end

    it "renders both the image and content" do
      expect(page).to have_selector("img[src='example.jpg']")
      expect(page).to have_selector("figure", text: "Figure caption")
    end
  end
end
