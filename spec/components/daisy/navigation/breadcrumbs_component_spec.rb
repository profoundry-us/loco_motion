require "rails_helper"

RSpec.describe Daisy::Navigation::BreadcrumbsComponent, type: :component do
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "basic breadcrumbs" do
    let(:breadcrumbs) { described_class.new }

    before do
      render_inline(breadcrumbs) do |b|
        b.with_item { "Home" }
      end
    end

    describe "rendering" do
      before { render_inline(breadcrumbs) }

      it "has the breadcrumbs class" do
        expect(page).to have_selector(".breadcrumbs")
      end

      it "renders a ul element inside" do
        expect(page).to have_selector(".breadcrumbs ul")
      end
    end
  end

  context "with text links" do
    let(:breadcrumbs) { described_class.new }
    let(:links) { [["Home", "#"], ["Docs", "#"], ["Components", "#"], ["Breadcrumbs", "#"]] }

    before do
      render_inline(breadcrumbs) do |b|
        links.each do |text, href|
          b.with_item { link_to text, href }
        end
      end
    end

    describe "rendering" do
      it "renders all items" do
        expect(page).to have_selector(".breadcrumbs ul li", count: links.length)
      end

      it "renders all links" do
        links.each do |text, href|
          expect(page).to have_link(text, href: href)
        end
      end

      it "maintains link order" do
        link_elements = page.all(".breadcrumbs ul li a").map(&:text)
        expect(link_elements).to eq(links.map(&:first))
      end
    end
  end

  context "with icons" do
    let(:breadcrumbs) { described_class.new }
    let(:links) { [
      ["Home", "home"],
      ["Docs", "document"],
      ["Components", "cube"],
      ["Breadcrumbs", "squares-2x2"]
    ] }
    let(:icon_css) { "size-4 mr-1 text-slate-600" }

    before do
      render_inline(breadcrumbs) do |b|
        links.each do |text, icon|
          b.with_item do
            link_to "#" do
              safe_join([
                heroicon_tag(icon, variant: :mini, class: icon_css),
                text
              ])
            end
          end
        end
      end
    end

    describe "rendering" do
      it "renders all items" do
        expect(page).to have_selector(".breadcrumbs ul li", count: links.length)
      end

      it "renders all icons" do
        links.each do |_, icon|
          expect(page).to have_selector(".breadcrumbs ul li svg[data-slot='icon']")
        end
      end

      it "applies icon CSS classes" do
        expect(page).to have_selector(".breadcrumbs ul li svg.#{icon_css.gsub(' ', '.')}")
      end

      it "renders all text labels" do
        links.each do |text, _|
          expect(page).to have_content(text)
        end
      end

      it "maintains item order" do
        text_elements = page.all(".breadcrumbs ul li").map { |li| li.text.strip }
        expect(text_elements).to eq(links.map(&:first))
      end
    end
  end

  context "with custom CSS" do
    let(:breadcrumbs) { described_class.new(css: "text-xl bg-base-200 p-4 rounded-lg") }

    before do
      render_inline(breadcrumbs) do |b|
        b.with_item { "Home" }
      end
    end

    describe "rendering" do
      before { render_inline(breadcrumbs) }

      it "includes custom classes" do
        expect(page).to have_selector(".breadcrumbs.text-xl.bg-base-200.p-4.rounded-lg")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".breadcrumbs")
      end
    end
  end

  context "with custom item CSS" do
    let(:breadcrumbs) { described_class.new }
    let(:item_css) { "text-primary font-bold" }

    before do
      render_inline(breadcrumbs) do |b|
        b.with_item(css: item_css) { "Home" }
      end
    end

    describe "rendering" do
      it "applies custom CSS to item" do
        expect(page).to have_selector(".breadcrumbs ul li.#{item_css.gsub(' ', '.')}")
      end
    end
  end

  context "with mixed content types" do
    let(:breadcrumbs) { described_class.new }

    before do
      render_inline(breadcrumbs) do |b|
        # Text only
        b.with_item { "Home" }

        # Link
        b.with_item { link_to "Products", "#" }

        # Link with icon
        b.with_item do
          link_to "#" do
            safe_join([
              heroicon_tag("cube", variant: :mini, class: "size-4 mr-1 text-slate-600"),
              "Categories"
            ])
          end
        end
      end
    end

    describe "rendering" do
      it "renders all items" do
        expect(page).to have_selector(".breadcrumbs ul li", count: 3)
      end

      it "renders plain text" do
        expect(page).to have_selector(".breadcrumbs ul li", text: "Home")
      end

      it "renders link with icon" do
        expect(page).to have_selector(".breadcrumbs ul li svg[data-slot='icon']")
      end

      it "maintains content order" do
        items = page.all(".breadcrumbs ul li").map { |li| li.text.strip }
        expect(items).to eq(["Home", "Products", "Categories"])
      end
    end
  end
end
