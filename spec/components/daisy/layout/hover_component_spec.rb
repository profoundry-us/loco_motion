# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::Layout::HoverComponent, type: :component do
  context "basic hover" do
    let(:hover) { described_class.new }

    before do
      render_inline(hover) do
        "Hover Content"
      end
    end

    describe "rendering" do
      it "has the hover-3d class" do
        expect(page).to have_selector(".hover-3d")
      end

      it "renders as a div by default" do
        expect(page).to have_selector("div.hover-3d")
      end

      it "renders the content" do
        expect(page).to have_text("Hover Content")
      end

      it "renders the eight empty hover zone divs" do
        # Capybara counts the wrapper itself if we look for plain `div`, so we
        # specifically scope to the empty children of the wrapper.
        empty_zones = page.find(".hover-3d").all("> div", visible: :all).select { |d| d.text.blank? }
        expect(empty_zones.length).to eq(Daisy::Layout::HoverComponent::HOVER_ZONE_COUNT)
      end
    end
  end

  context "with content elements" do
    let(:hover) { described_class.new }

    before do
      render_inline(hover) do
        content_tag(:figure, content_tag(:img, nil, src: "creditcard.webp", alt: "3D card"))
      end
    end

    it "renders the figure inside the wrapper" do
      expect(page).to have_selector(".hover-3d figure img[src='creditcard.webp']")
    end
  end

  context "with custom CSS" do
    let(:hover) { described_class.new(css: "my-12 mx-2 cursor-pointer") }

    before do
      render_inline(hover) { "Custom" }
    end

    it "applies custom CSS classes alongside the hover-3d class" do
      expect(page).to have_selector(".hover-3d.my-12.mx-2.cursor-pointer")
    end
  end

  context "with href" do
    let(:href) { "/cards/123" }
    let(:hover) { described_class.new(href: href) }

    before do
      render_inline(hover) { "Linked" }
    end

    it "renders as an anchor tag" do
      expect(page).to have_selector("a.hover-3d")
    end

    it "has the correct href" do
      expect(page).to have_selector("a[href='#{href}']")
    end
  end

  context "with href and target" do
    let(:href) { "https://example.com" }
    let(:hover) { described_class.new(href: href, target: "_blank") }

    before do
      render_inline(hover) { "External" }
    end

    it "applies the target attribute" do
      expect(page).to have_selector("a.hover-3d[target='_blank'][href='#{href}']")
    end
  end

  context "with custom HTML attributes" do
    let(:hover) { described_class.new(html: { id: "my-hover", data: { test: "value" } }) }

    before do
      render_inline(hover) { "Attrs" }
    end

    it "passes attributes through to the wrapper" do
      expect(page).to have_selector(".hover-3d#my-hover[data-test='value']")
    end
  end
end
