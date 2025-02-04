require "rails_helper"

RSpec.describe Daisy::DataDisplay::CarouselComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  context "with no items" do
    before do
      render_inline(described_class.new)
    end

    describe "rendering" do
      it "renders the carousel container" do
        expect(page).to have_selector(".carousel")
      end

      it "has no carousel items" do
        expect(page).not_to have_selector(".carousel-item")
      end
    end
  end

  context "with single item" do
    let(:item_content) { "Item 1" }

    before do
      render_inline(described_class.new) do |c|
        c.with_item { item_content }
      end
    end

    describe "rendering" do
      it "renders the carousel container" do
        expect(page).to have_selector(".carousel")
      end

      it "renders one carousel item" do
        expect(page).to have_selector(".carousel-item", count: 1)
      end

      it "renders the item content" do
        expect(page).to have_selector(".carousel-item", text: item_content)
      end
    end
  end

  context "with multiple items" do
    let(:items) { ["Item 1", "Item 2", "Item 3"] }

    before do
      render_inline(described_class.new) do |c|
        items.each do |item|
          c.with_item { item }
        end
      end
    end

    describe "rendering" do
      it "renders the carousel container" do
        expect(page).to have_selector(".carousel")
      end

      it "renders correct number of carousel items" do
        expect(page).to have_selector(".carousel-item", count: items.length)
      end

      it "renders all item contents" do
        items.each do |item|
          expect(page).to have_selector(".carousel-item", text: item)
        end
      end
    end
  end

  context "with custom CSS classes" do
    let(:carousel_class) { "custom-carousel" }
    let(:item_class) { "custom-item" }

    before do
      render_inline(described_class.new(css: carousel_class)) do |c|
        c.with_item(css: item_class) { "Item" }
      end
    end

    describe "rendering" do
      it "includes custom carousel class" do
        expect(page).to have_selector(".carousel.#{carousel_class}")
      end

      it "includes custom item class" do
        expect(page).to have_selector(".carousel-item.#{item_class}")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".carousel")
        expect(page).to have_selector(".carousel-item")
      end
    end
  end

  context "with complex items" do
    before do
      render_inline(described_class.new(css: "h-96 gap-x-2")) do |c|
        c.with_item(css: "relative") do
          content_tag(:div, class: "image-container") do
            image_tag("test.jpg", alt: "Test Image", class: "rounded-lg h-96") +
            content_tag(:div, "Caption", class: "caption")
          end
        end
      end
    end

    describe "rendering" do
      it "renders nested structure correctly" do
        expect(page).to have_selector(".carousel .carousel-item .image-container img.h-96")
        expect(page).to have_selector(".carousel .carousel-item .image-container .caption")
      end

      it "preserves custom classes" do
        expect(page).to have_selector(".carousel.h-96.gap-x-2")
        expect(page).to have_selector(".carousel-item.relative")
      end

      it "maintains image attributes" do
        expect(page).to have_selector("img[alt='Test Image']")
        expect(page).to have_selector("img[src*='test.jpg']")
      end
    end
  end

  context "with items containing links" do
    let(:link_url) { "https://example.com" }
    let(:link_text) { "Click me" }

    before do
      render_inline(described_class.new) do |c|
        c.with_item do
          link_to(link_text, link_url, target: "_blank")
        end
      end
    end

    describe "rendering" do
      it "renders the link correctly" do
        expect(page).to have_link(link_text, href: link_url)
      end

      it "preserves link attributes" do
        expect(page).to have_selector("a[target='_blank']")
      end
    end
  end
end
