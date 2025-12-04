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

    it "renders image before content by default" do
      html = page.native.to_html
      image_index = html.index('<img')
      content_index = html.index('Figure caption')
      expect(image_index).to be < content_index
    end
  end

  context "with position: top" do
    let(:figure) { described_class.new(src: "example.jpg", position: :top) }

    before do
      render_inline(figure) { "Figure caption" }
    end

    it "renders image before content" do
      html = page.native.to_html
      image_index = html.index('<img')
      content_index = html.index('Figure caption')
      expect(image_index).to be < content_index
    end
  end

  context "with position: bottom" do
    let(:figure) { described_class.new(src: "example.jpg", position: :bottom) }

    before do
      render_inline(figure) { "Figure caption" }
    end

    it "renders content before image" do
      html = page.native.to_html
      content_index = html.index('Figure caption')
      image_index = html.index('<img')
      expect(content_index).to be < image_index
    end

    it "still renders both elements" do
      expect(page).to have_selector("img[src='example.jpg']")
      expect(page).to have_selector("figure", text: "Figure caption")
    end
  end

  context "with position: bottom and no content" do
    let(:figure) { described_class.new(src: "example.jpg", position: :bottom) }

    before do
      render_inline(figure)
    end

    it "renders the image" do
      expect(page).to have_selector("img[src='example.jpg']")
    end
  end

  context "with position: bottom and no image" do
    let(:figure) { described_class.new(position: :bottom) }

    before do
      render_inline(figure) { "Content only" }
    end

    it "renders the content" do
      expect(page).to have_selector("figure", text: "Content only")
    end

    it "does not render an image" do
      expect(page).not_to have_selector("img")
    end
  end

  context "with invalid position" do
    it "raises an ArgumentError" do
      expect {
        described_class.new(position: "invalid")
      }.to raise_error(ArgumentError, "position must be :top or :bottom, got 'invalid'")
    end
  end

  context "with nil position" do
    let(:figure) { described_class.new(src: "example.jpg", position: nil) }

    before do
      render_inline(figure) { "Figure caption" }
    end

    it "defaults to top positioning" do
      html = page.native.to_html
      image_index = html.index('<img')
      content_index = html.index('Figure caption')
      expect(image_index).to be < content_index
    end
  end
end
