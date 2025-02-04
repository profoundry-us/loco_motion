require "rails_helper"

RSpec.describe Daisy::Layout::DrawerComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "with basic configuration" do
    before do
      render_inline(described_class.new)
    end

    describe "rendering" do
      it "renders the drawer container" do
        expect(page).to have_selector(".drawer")
      end

      it "renders the input toggle" do
        expect(page).to have_selector("input.drawer-toggle[type='checkbox']")
      end

      it "renders the content wrapper" do
        expect(page).to have_selector(".drawer-content")
      end

      it "generates a unique ID" do
        expect(page).to have_selector("input[id]")
      end
    end
  end

  context "with custom ID" do
    let(:custom_id) { "custom-drawer" }

    before do
      render_inline(described_class.new(id: custom_id)) do |drawer|
        drawer.with_sidebar { "Sidebar" }
      end
    end

    describe "rendering" do
      it "uses the custom ID for input" do
        expect(page).to have_selector("input##{custom_id}")
      end

      it "uses the custom ID for overlay" do
        expect(page).to have_selector("label.drawer-overlay[for='#{custom_id}']")
      end
    end
  end

  context "with sidebar" do
    let(:sidebar_content) { "Sidebar Content" }

    before do
      render_inline(described_class.new) do |drawer|
        drawer.with_sidebar { sidebar_content }
      end
    end

    describe "rendering" do
      it "renders the sidebar" do
        expect(page).to have_selector(".drawer-side", text: sidebar_content)
      end

      it "renders the overlay" do
        expect(page).to have_selector("label.drawer-overlay[aria-label='close sidebar']")
      end

      it "uses the drawer ID for overlay" do
        drawer_id = page.find("input.drawer-toggle")["id"]
        expect(page).to have_selector("label.drawer-overlay[for='#{drawer_id}']")
      end
    end
  end

  context "with right drawer" do
    before do
      render_inline(described_class.new(css: "drawer-end")) do |drawer|
        drawer.with_sidebar { "Right Sidebar" }
      end
    end

    describe "rendering" do
      it "includes drawer-end class" do
        expect(page).to have_selector(".drawer.drawer-end")
      end
    end
  end

  context "with custom content" do
    let(:content_text) { "Main Content" }

    before do
      render_inline(described_class.new) { content_text }
    end

    describe "rendering" do
      it "renders the content in content wrapper" do
        expect(page).to have_selector(".drawer-content", text: content_text)
      end
    end
  end

  context "with custom sidebar styles" do
    let(:sidebar_class) { "custom-sidebar" }

    before do
      render_inline(described_class.new) do |drawer|
        drawer.with_sidebar(css: sidebar_class) { "Styled Sidebar" }
      end
    end

    describe "rendering" do
      it "includes custom sidebar class" do
        expect(page).to have_selector(".drawer-side.#{sidebar_class}")
      end
    end
  end

  context "with complex configuration" do
    let(:drawer_id) { "complex-drawer" }
    let(:drawer_class) { "custom-drawer" }
    let(:content_text) { "Main Content" }
    let(:sidebar_text) { "Sidebar Content" }
    let(:sidebar_class) { "custom-sidebar" }

    before do
      render_inline(described_class.new(id: drawer_id, css: drawer_class)) do |drawer|
        drawer.with_sidebar(css: sidebar_class) { sidebar_text }
        content_text
      end
    end

    describe "rendering" do
      it "includes all custom classes" do
        expect(page).to have_selector(".drawer.#{drawer_class}")
        expect(page).to have_selector(".drawer-side.#{sidebar_class}")
      end

      it "uses custom ID" do
        expect(page).to have_selector("input##{drawer_id}")
        expect(page).to have_selector("label[for='#{drawer_id}']")
      end

      it "renders content and sidebar" do
        expect(page).to have_selector(".drawer-content", text: content_text)
        expect(page).to have_selector(".drawer-side", text: sidebar_text)
      end

      it "renders components in correct order" do
        drawer_html = page.find(".drawer").native.inner_html
        input_pos = drawer_html.index("drawer-toggle")
        content_pos = drawer_html.index("drawer-content")
        sidebar_pos = drawer_html.index("drawer-side")

        expect(input_pos).to be < content_pos
        expect(content_pos).to be < sidebar_pos
      end
    end
  end

  context "with basic sidebar configuration" do
    before do
      render_inline(described_class.new) do |drawer|
        drawer.with_sidebar { "Basic Sidebar" }
      end
    end

    describe "rendering" do
      it "includes drawer-side class" do
        expect(page).to have_selector(".drawer-side")
      end
    end
  end

  context "with custom sidebar styles" do
    let(:sidebar_class) { "custom-sidebar" }

    before do
      render_inline(described_class.new) do |drawer|
        drawer.with_sidebar(css: sidebar_class) { "Styled Sidebar" }
      end
    end

    describe "rendering" do
      it "includes custom class" do
        expect(page).to have_selector(".drawer-side.#{sidebar_class}")
      end
    end
  end
end
