# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::Layout::HoverGalleryComponent, type: :component do
  context "basic rendering" do
    before { render_inline(described_class.new) }

    it "renders a figure tag" do
      expect(page).to have_selector("figure")
    end

    it "has the hover-gallery class" do
      expect(page).to have_selector("figure.hover-gallery")
    end
  end

  context "with images via slots" do
    before do
      render_inline(described_class.new) do |gallery|
        gallery.with_image(src: "beach.jpg", alt: "Beach")
        gallery.with_image(src: "desert.jpg", alt: "Desert")
        gallery.with_image(src: "forest.jpg", alt: "Forest")
      end
    end

    it "renders the correct number of images" do
      expect(page).to have_selector("figure.hover-gallery img", count: 3)
    end

    it "passes src attributes through" do
      expect(page).to have_selector("img[src='beach.jpg']")
      expect(page).to have_selector("img[src='desert.jpg']")
      expect(page).to have_selector("img[src='forest.jpg']")
    end

    it "passes alt attributes through" do
      expect(page).to have_selector("img[alt='Beach']")
    end
  end

  context "with srcs convenience parameter" do
    let(:srcs) { %w[beach.jpg desert.jpg forest.jpg] }

    before { render_inline(described_class.new(srcs: srcs)) }

    it "renders one image per src" do
      expect(page).to have_selector("figure.hover-gallery img", count: 3)
    end

    it "sets the src attribute on each image" do
      srcs.each do |src|
        expect(page).to have_selector("img[src='#{src}']")
      end
    end
  end

  context "with custom CSS classes" do
    before { render_inline(described_class.new(css: "max-w-60 w-full")) }

    it "applies custom CSS alongside hover-gallery" do
      expect(page).to have_selector("figure.hover-gallery.max-w-60.w-full")
    end
  end

  context "with custom HTML attributes" do
    before do
      render_inline(described_class.new(html: { id: "my-gallery", data: { test: "value" } }))
    end

    it "passes HTML attributes to the wrapper" do
      expect(page).to have_selector("figure.hover-gallery#my-gallery[data-test='value']")
    end
  end

  context "with block content fallback" do
    before do
      render_inline(described_class.new) do
        "<img src='custom.jpg' alt='Custom'>".html_safe
      end
    end

    it "renders the block content inside the figure" do
      expect(page).to have_selector("figure.hover-gallery img[src='custom.jpg']")
    end
  end
end
