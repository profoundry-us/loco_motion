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

      it "renders a default trigger div" do
        expect(page).to have_css "div.fab div.btn[role='button'][tabindex='0']"
      end
    end
  end

  context "with a button slot" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-primary btn-circle btn-lg") { "F" }
      end
    end

    describe "rendering" do
      it "renders the button as a button element" do
        expect(page).to have_css "button.btn.btn-primary.btn-circle.btn-lg"
      end

      it "renders button content" do
        expect(page).to have_content "F"
      end

      it "does not render the default trigger" do
        expect(page).not_to have_css("div.btn[role='button']")
      end
    end
  end

  context "with a custom activator" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_activator(css: "custom-trigger") do
          tag.span("Custom", class: "custom-icon")
        end
      end
    end

    describe "rendering" do
      it "renders the custom activator" do
        expect(page).to have_css ".custom-icon"
      end

      it "adds accessibility attributes to activator" do
        expect(page).to have_css "[role='button'][tabindex='0']"
      end

      it "renders the custom content" do
        expect(page).to have_content "Custom"
      end
    end
  end

  context "with action buttons" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-primary btn-circle btn-lg") { "+" }
        fab.with_action(css: "btn-circle btn-lg") { "A" }
        fab.with_action(css: "btn-circle btn-lg") { "B" }
        fab.with_action(css: "btn-circle btn-lg") { "C" }
      end
    end

    describe "rendering" do
      it "renders the trigger button" do
        expect(page).to have_css "button.btn.btn-primary"
        expect(page).to have_content "+"
      end

      it "renders all action buttons" do
        expect(page).to have_css "button.btn", count: 4
      end

      it "renders action content" do
        expect(page).to have_content "A"
        expect(page).to have_content "B"
        expect(page).to have_content "C"
      end

      it "renders actions after the trigger" do
        fab_html = page.find(".fab").native.inner_html
        trigger_pos = fab_html.index("btn-primary")
        action_pos = fab_html.index("btn-circle btn-lg")

        expect(trigger_pos).to be < action_pos
      end
    end
  end

  context "with close slot" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-circle btn-lg") { "F" }
        fab.with_close { tag.button "X", class: "btn btn-circle" }
        fab.with_action(css: "btn-circle btn-lg") { "A" }
      end
    end

    describe "rendering" do
      it "renders the close button in a fab-close wrapper" do
        expect(page).to have_css ".fab-close"
      end

      it "renders the close content" do
        expect(page).to have_content "X"
      end
    end
  end

  context "with main_action slot" do
    before do
      render_inline(described_class.new) do |fab|
        fab.with_button(css: "btn-circle btn-lg") { "F" }
        fab.with_main_action { tag.button "Save", class: "btn btn-primary" }
        fab.with_action(css: "btn-circle btn-lg") { "A" }
      end
    end

    describe "rendering" do
      it "renders the main action in a fab-main-action wrapper" do
        expect(page).to have_css ".fab-main-action"
      end

      it "renders the main action content" do
        expect(page).to have_content "Save"
      end
    end
  end

  context "with flower variant" do
    before do
      render_inline(described_class.new(css: "fab-flower")) do |fab|
        fab.with_button(css: "btn-primary btn-circle btn-lg") { "F" }
        fab.with_action(css: "btn-circle btn-lg") { "A" }
        fab.with_action(css: "btn-circle btn-lg") { "B" }
        fab.with_action(css: "btn-circle btn-lg") { "C" }
      end
    end

    describe "rendering" do
      it "applies flower class to wrapper" do
        expect(page).to have_css ".fab.fab-flower"
      end

      it "renders the trigger" do
        expect(page).to have_css "button.btn.btn-primary"
      end

      it "renders all action buttons" do
        expect(page).to have_css "button.btn", count: 4
      end
    end
  end

  context "with custom CSS on component" do
    before do
      render_inline(described_class.new(css: "custom-fab"))
    end

    describe "rendering" do
      it "applies custom CSS to the wrapper" do
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

  context "with block content and no button slot" do
    before do
      render_inline(described_class.new) { "F" }
    end

    describe "rendering" do
      it "renders the content in a default trigger" do
        expect(page).to have_css "div.btn[role='button'][tabindex='0']"
        expect(page).to have_content "F"
      end
    end
  end
end
