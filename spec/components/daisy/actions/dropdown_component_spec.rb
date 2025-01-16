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
        expect(page).to have_css ".menu"
      end

      it "renders item content" do
        expect(page).to have_content "Item 1"
        expect(page).to have_content "Item 2"
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
    end
  end
end
