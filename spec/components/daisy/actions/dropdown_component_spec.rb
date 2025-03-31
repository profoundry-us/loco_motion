require "rails_helper"

RSpec.describe Daisy::Actions::DropdownComponent, type: :component do
  context "with no options" do
    let(:dropdown) { described_class.new }

    before do
      render_inline(dropdown)
    end

    describe "rendering" do
      it "renders a dropdown container" do
        expect(page).to have_css ".dropdown"
      end

      it "renders a default button" do
        expect(page).to have_css "button.btn"
      end
    end
  end

  context "with a title" do
    let(:dropdown) { described_class.new("Options") }

    before do
      render_inline(dropdown)
    end

    describe "rendering" do
      it "renders a button with the title" do
        expect(page).to have_button "Options"
      end
    end
  end

  context "with items" do
    let(:dropdown) { described_class.new }

    before do
      render_inline(dropdown) do |d|
        d.with_item { "Item 1" }
        d.with_item { "Item 2" }
      end
    end

    describe "rendering" do
      it "renders the menu" do
        expect(page).to have_css "ul[class*='where:menu']"
      end

      it "renders menu as unordered list" do
        expect(page).to have_css "ul.dropdown-content"
      end

      it "renders items as list items" do
        expect(page).to have_css "li", count: 2
      end

      it "renders item content" do
        expect(page).to have_content "Item 1"
        expect(page).to have_content "Item 2"
      end

      it "applies default menu styles" do
        # Check each class separately to avoid issues with class ordering
        expect(page).to have_css "ul.dropdown-content"
        expect(page).to have_css "ul[class*='where:menu']"
        expect(page).to have_css "ul[class*='where:bg-base-100']"
        expect(page).to have_css "ul[class*='where:rounded-box']"
        expect(page).to have_css "ul[class*='where:shadow']"
        expect(page).to have_css "ul[class*='where:w-52']"
        expect(page).to have_css "ul[class*='where:p-2']"
        expect(page).to have_css "ul[class*='where:z-[1]']"
      end
    end
  end

  context "with custom activator" do
    let(:dropdown) { described_class.new }

    before do
      render_inline(dropdown) do |d|
        d.with_activator { tag.div "Click me", class: "custom-activator" }
      end
    end

    describe "rendering" do
      it "renders the custom activator" do
        expect(page).to have_css ".custom-activator"
      end

      it "adds accessibility attributes to activator" do
        expect(page).to have_css "[role='button'][tabindex='0']"
      end

      it "does not render default button" do
        expect(page).not_to have_css "button.btn"
      end
    end
  end

  context "with custom button" do
    let(:dropdown) { described_class.new }

    before do
      render_inline(dropdown) do |d|
        d.with_button(icon: "heart", css: "btn-primary") { "Custom Button" }
      end
    end

    describe "rendering" do
      it "renders the custom button" do
        expect(page).to have_button "Custom Button"
      end

      it "applies custom button classes" do
        expect(page).to have_css "button.btn.btn-primary"
      end

      it "does not render default button" do
        expect(page).to have_css "button.btn", count: 1
      end
    end
  end

  context "with custom content and no items" do
    let(:content) { "Custom dropdown content" }

    before do
      render_inline(described_class.new) { content }
    end

    describe "rendering" do
      it "renders custom content" do
        expect(page).to have_content content
      end

      it "does not render menu structure" do
        expect(page).not_to have_css "ul[class*='where:menu']"
        expect(page).not_to have_css "li"
      end
    end
  end

  context "with custom dropdown position" do
    let(:position_class) { "dropdown-end" }

    before do
      render_inline(described_class.new(css: position_class))
    end

    describe "rendering" do
      it "applies position class" do
        expect(page).to have_css ".dropdown.#{position_class}"
      end
    end
  end

  context "with hover trigger" do
    before do
      render_inline(described_class.new(css: "dropdown-hover"))
    end

    describe "rendering" do
      it "applies hover class" do
        expect(page).to have_css ".dropdown.dropdown-hover"
      end
    end
  end

  context "with complex configuration" do
    let(:title) { "Complex Dropdown" }
    let(:custom_class) { "custom-dropdown" }
    let(:items) { ["Item 1", "Item 2", "Item 3"] }

    before do
      render_inline(described_class.new(title, css: custom_class)) do |d|
        d.with_button(css: "btn-primary", icon: "menu") { title }
        items.each { |item| d.with_item { item } }
      end
    end

    describe "rendering" do
      it "applies custom classes" do
        expect(page).to have_css ".dropdown.#{custom_class}"
      end

      it "renders custom button" do
        expect(page).to have_css "button.btn.btn-primary"
        expect(page).to have_button title
      end

      it "renders all items" do
        items.each { |item| expect(page).to have_content item }
      end

      it "maintains correct structure" do
        dropdown_html = page.find(".dropdown").native.inner_html
        button_pos = dropdown_html.index("button")
        menu_pos = dropdown_html.index("dropdown-content")

        expect(button_pos).to be < menu_pos
      end
    end
  end
end
