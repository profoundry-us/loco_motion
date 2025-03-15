require "rails_helper"

RSpec.describe Daisy::Navigation::MenuComponent, type: :component do
  include ActionView::Helpers::UrlHelper

  context "basic menu" do
    let(:menu) { described_class.new }

    before do
      render_inline(menu) do |m|
        m.with_item { "Item 1" }
      end
    end

    describe "rendering" do
      it "has the menu class" do
        expect(page).to have_selector(".menu")
      end

      it "renders as a ul element" do
        expect(page).to have_selector("ul.menu")
      end

      it "renders items as li elements" do
        expect(page).to have_selector("ul.menu li")
      end
    end
  end

  context "with text items" do
    let(:menu) { described_class.new }
    let(:items) { ["Item 1", "Item 2", "Item 3"] }

    before do
      render_inline(menu) do |m|
        items.each do |item|
          m.with_item { item }
        end
      end
    end

    describe "rendering" do
      it "renders all items" do
        expect(page).to have_selector("ul.menu li", count: items.length)
      end

      it "renders all text content" do
        items.each do |item|
          expect(page).to have_content(item)
        end
      end

      it "maintains item order" do
        rendered_items = page.all("ul.menu li").map(&:text)
        expect(rendered_items).to eq(items)
      end
    end
  end

  context "with links" do
    let(:menu) { described_class.new }
    let(:links) { [
      ["Home", "/"],
      ["About", "/about"],
      ["Contact", "/contact"]
    ] }

    before do
      render_inline(menu) do |m|
        links.each do |text, href|
          m.with_item { link_to text, href }
        end
      end
    end

    describe "rendering" do
      it "renders all items" do
        expect(page).to have_selector("ul.menu li", count: links.length)
      end

      it "renders all links" do
        links.each do |text, href|
          expect(page).to have_link(text, href: href)
        end
      end

      it "maintains link order" do
        rendered_links = page.all("ul.menu li a").map(&:text)
        expect(rendered_links).to eq(links.map(&:first))
      end
    end
  end

  context "with group titles" do
    let(:menu) { described_class.new }

    before do
      render_inline(menu) do |m|
        # Title via keyword argument
        m.with_item(title: "Group 1") do
          link_to "Item 1-1", "#"
        end

        # Title via positional argument
        m.with_item("Group 2") do
          link_to "Item 2-1", "#"
        end

        # No title
        m.with_item do
          link_to "Item 3", "#"
        end
      end
    end

    describe "rendering" do
      it "renders group titles" do
        expect(page).to have_selector("h2.menu-title", text: "Group 1")
        expect(page).to have_selector("h2.menu-title", text: "Group 2")
      end

      it "renders items with titles" do
        expect(page).to have_selector("li", text: /Group 1.*Item 1-1/)
        expect(page).to have_selector("li", text: /Group 2.*Item 2-1/)
      end

      it "renders items without titles" do
        expect(page).to have_link("Item 3")
      end

      it "maintains content order" do
        items = page.all("ul.menu li").map { |li| li.text.strip }
        expected_order = ["Group 1Item 1-1", "Group 2Item 2-1", "Item 3"]
        expect(items).to eq(expected_order)
      end
    end
  end

  context "with disabled items" do
    let(:menu) { described_class.new }

    before do
      render_inline(menu) do |m|
        m.with_item { "Enabled Item" }
        m.with_item(disabled: true) { link_to "Disabled Item", "#", tabindex: -1 }
        m.with_item(disabled: true, title: "Group") { link_to "Disabled Group Item", "#", tabindex: -1 }
      end
    end

    describe "rendering" do
      it "applies menu-disabled class to disabled items" do
        expect(page).to have_selector("li.menu-disabled", text: "Disabled Item")
        expect(page).to have_selector("li.menu-disabled", text: /Disabled Group Item/)
      end

      it "applies pointer-events-none to disabled items" do
        expect(page).to have_selector("li.pointer-events-none", text: "Disabled Item")
        expect(page).to have_selector("li.pointer-events-none", text: /Disabled Group Item/)
      end

      it "sets tabindex to -1 on disabled links" do
        expect(page).to have_selector("li.menu-disabled a[tabindex='-1']")
      end

      it "does not apply disabled classes to enabled items" do
        expect(page).not_to have_selector("li.menu-disabled", text: "Enabled Item")
        expect(page).not_to have_selector("li.pointer-events-none", text: "Enabled Item")
      end
    end
  end

  context "with custom CSS" do
    let(:menu) { described_class.new(css: "bg-base-200 rounded-lg p-4") }
    let(:item_css) { "text-primary font-bold" }

    before do
      render_inline(menu) do |m|
        m.with_item { "Regular Item" }
        m.with_item(css: item_css) { "Custom Item" }
      end
    end

    describe "rendering" do
      it "includes custom menu classes" do
        expect(page).to have_selector("ul.menu.bg-base-200.rounded-lg.p-4")
      end

      it "maintains default menu class" do
        expect(page).to have_selector("ul.menu")
      end

      it "applies custom CSS to specific items" do
        expect(page).to have_selector("li.#{item_css.gsub(' ', '.')}", text: "Custom Item")
      end
    end
  end

  context "horizontal menu" do
    let(:menu) { described_class.new(css: "menu-horizontal") }

    before do
      render_inline(menu) do |m|
        m.with_item { link_to "Item 1", "#" }
        m.with_item(disabled: true) { link_to "Item 2", "#", tabindex: -1 }
        m.with_item { link_to "Item 3", "#", class: "active" }
      end
    end

    describe "rendering" do
      it "has the menu-horizontal class" do
        expect(page).to have_selector("ul.menu.menu-horizontal")
      end

      it "renders active items" do
        expect(page).to have_selector("li a.active", text: "Item 3")
      end
    end
  end

  context "with nested menus" do
    let(:menu) { described_class.new }

    before do
      render_inline(menu) do |m|
        m.with_item(title: "Parent 1") do
          m.daisy_menu do |submenu|
            submenu.with_item { link_to "Child 1-1", "#" }
            submenu.with_item { link_to "Child 1-2", "#" }
          end
        end

        m.with_item(title: "Parent 2") do
          m.daisy_menu do |submenu|
            submenu.with_item { link_to "Child 2-1", "#" }
            submenu.with_item { link_to "Child 2-2", "#" }
          end
        end
      end
    end

    describe "rendering" do
      it "renders parent items with titles" do
        expect(page).to have_selector("h2.menu-title", text: "Parent 1")
        expect(page).to have_selector("h2.menu-title", text: "Parent 2")
      end

      it "renders nested menus" do
        expect(page).to have_selector("ul.menu ul.menu", count: 2)
      end

      it "renders nested items" do
        expect(page).to have_link("Child 1-1")
        expect(page).to have_link("Child 1-2")
        expect(page).to have_link("Child 2-1")
        expect(page).to have_link("Child 2-2")
      end
    end
  end
end
