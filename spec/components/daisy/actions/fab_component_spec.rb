require "rails_helper"

RSpec.describe Daisy::Actions::FabComponent, type: :component do
  context "with no options" do
    before do
      render_inline(described_class.new)
    end

    describe "rendering" do
      it "renders a fab container" do
        expect(page).to have_css ".fab"
      end
    end
  end

  context "with a button" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-primary btn-circle btn-lg") { "F" }
      end
    end

    describe "rendering" do
      it "renders the button" do
        expect(page).to have_button "F"
      end

      it "applies button classes" do
        expect(page).to have_css "button.btn.btn-primary.btn-circle.btn-lg"
      end
    end
  end

  context "with a custom activator" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_activator { tag.div "Custom", class: "custom-trigger" }
      end
    end

    describe "rendering" do
      it "renders the custom activator" do
        expect(page).to have_css ".custom-trigger"
      end

      it "adds accessibility attributes to activator" do
        expect(page).to have_css "[role='button'][tabindex='0']"
      end

      it "does not render a default button" do
        expect(page).not_to have_css "button.btn"
      end
    end
  end

  context "with actions" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-primary btn-circle btn-lg") { "F" }
        fab.with_action { tag.button "A", class: "btn btn-circle btn-lg" }
        fab.with_action { tag.button "B", class: "btn btn-circle btn-lg" }
        fab.with_action { tag.button "C", class: "btn btn-circle btn-lg" }
      end
    end

    describe "rendering" do
      it "renders the trigger button" do
        expect(page).to have_button "F"
      end

      it "renders all action buttons" do
        expect(page).to have_button "A"
        expect(page).to have_button "B"
        expect(page).to have_button "C"
      end

      it "renders the correct number of action buttons" do
        expect(page).to have_css ".fab button.btn-circle", count: 4
      end
    end
  end

  context "with close slot" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-circle btn-lg") { "F" }
        fab.with_close { tag.button "X", class: "btn btn-circle" }
        fab.with_action { tag.button "A", class: "btn btn-circle" }
      end
    end

    describe "rendering" do
      it "renders the close button in a fab-close wrapper" do
        expect(page).to have_css ".fab-close"
      end

      it "renders the close content" do
        expect(page).to have_button "X"
      end
    end
  end

  context "with main_action slot" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-circle btn-lg") { "F" }
        fab.with_main_action { tag.button "Save", class: "btn btn-primary" }
        fab.with_action { tag.button "A", class: "btn btn-circle" }
      end
    end

    describe "rendering" do
      it "renders the main action in a fab-main-action wrapper" do
        expect(page).to have_css ".fab-main-action"
      end

      it "renders the main action content" do
        expect(page).to have_button "Save"
      end
    end
  end

  context "with flower variant" do
    before do
      render_inline(described_class.new(css: "fab-flower")) do |fab|
        fab.with_button(css: "btn-circle btn-primary btn-lg") { "F" }
        fab.with_action { tag.button "A", class: "btn btn-circle btn-lg" }
        fab.with_action { tag.button "B", class: "btn btn-circle btn-lg" }
        fab.with_action { tag.button "C", class: "btn btn-circle btn-lg" }
      end
    end

    describe "rendering" do
      it "applies the fab-flower class" do
        expect(page).to have_css ".fab.fab-flower"
      end

      it "renders action buttons" do
        expect(page).to have_button "A"
        expect(page).to have_button "B"
        expect(page).to have_button "C"
      end
    end
  end

  context "with custom CSS" do
    before do
      render_inline(described_class.new(css: "custom-fab"))
    end

    describe "rendering" do
      it "applies custom classes" do
        expect(page).to have_css ".fab.custom-fab"
      end
    end
  end

  context "with custom HTML attributes" do
    before do
      render_inline(described_class.new(
        html: { id: "my-fab", data: { test: "value" } }
      ))
    end

    describe "rendering" do
      it "passes attributes to the component" do
        expect(page).to have_css ".fab#my-fab[data-test='value']"
      end
    end
  end
end
