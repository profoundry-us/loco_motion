require "rails_helper"

RSpec.describe Daisy::Navigation::TabsComponent, type: :component do
  context "basic tabs" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "Tab 1") { "Content 1" }
        t.with_tab(title: "Tab 2") { "Content 2" }
      end
    end

    describe "rendering" do
      it "has the tabs class" do
        expect(page).to have_selector(".tabs")
      end

      it "has the tablist role" do
        expect(page).to have_selector("[role='tablist']")
      end

      it "renders all tabs" do
        expect(page).to have_selector(".tab", count: 2)
      end

      it "renders tab titles" do
        expect(page).to have_selector(".tab", text: "Tab 1")
        expect(page).to have_selector(".tab", text: "Tab 2")
      end

      it "renders tab content" do
        expect(page).to have_selector(".tab-content", text: "Content 1")
        expect(page).to have_selector(".tab-content", text: "Content 2")
      end

      it "sets proper ARIA attributes" do
        expect(page).to have_selector(".tab[role='tab'][aria-label='Tab 1']")
        expect(page).to have_selector(".tab[role='tab'][aria-label='Tab 2']")
        expect(page).to have_selector(".tab-content[role='tabpanel']")
      end
    end
  end

  context "with active tab" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "Tab 1") { "Content 1" }
        t.with_tab(title: "Tab 2", active: true) { "Content 2" }
        t.with_tab(title: "Tab 3") { "Content 3" }
      end
    end

    describe "rendering" do
      it "applies active class to active tab" do
        expect(page).to have_selector(".tab.tab-active", text: "Tab 2")
      end

      it "does not apply active class to inactive tabs" do
        expect(page).not_to have_selector(".tab.tab-active", text: "Tab 1")
        expect(page).not_to have_selector(".tab.tab-active", text: "Tab 3")
      end
    end
  end

  context "with disabled tab" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "Tab 1") { "Content 1" }
        t.with_tab(title: "Tab 2", disabled: true) { "Content 2" }
      end
    end

    describe "rendering" do
      it "sets disabled attribute on disabled tab" do
        expect(page).to have_selector(".tab[disabled]", text: "Tab 2")
      end

      it "does not set disabled attribute on enabled tab" do
        expect(page).not_to have_selector(".tab[disabled]", text: "Tab 1")
      end
    end
  end

  context "with complex title" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab do |tab|
          tab.with_title do
            '<span class="text-primary">Custom Title</span>'.html_safe
          end
          "Content"
        end
      end
    end

    describe "rendering" do
      it "renders complex title content" do
        expect(page).to have_selector(".tab .text-primary", text: "Custom Title")
      end
    end
  end

  context "with custom content" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab do |tab|
          tab.with_title { "Tab" }
          tab.with_custom_content do
            '<div class="custom-panel">Custom Content</div>'.html_safe
          end
        end
      end
    end

    describe "rendering" do
      it "renders custom content instead of default wrapper" do
        expect(page).not_to have_selector(".tab-content")
        expect(page).to have_selector(".custom-panel", text: "Custom Content")
      end
    end
  end

  context "in radio mode" do
    let(:tabs) { described_class.new(radio: true) }
    let(:tab_name) { nil }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "Option 1", value: "1") { "Content 1" }
        t.with_tab(title: "Option 2", value: "2", checked: true) { "Content 2" }
        t.with_tab(title: "Option 3", value: "3", disabled: true) { "Content 3" }
      end
    end

    describe "rendering" do
      it "renders radio inputs" do
        expect(page).to have_selector("input[type='radio'].tab", count: 3)
      end

      it "sets name attribute on all inputs" do
        name = page.find("input[type='radio'].tab[value='1']")["name"]
        expect(page).to have_selector("input[type='radio'].tab[name='#{name}']", count: 3)
      end

      it "sets values on inputs" do
        expect(page).to have_selector("input[type='radio'].tab[value='1']")
        expect(page).to have_selector("input[type='radio'].tab[value='2']")
        expect(page).to have_selector("input[type='radio'].tab[value='3']")
      end

      it "sets checked state" do
        expect(page).to have_selector("input[type='radio'].tab[checked]", count: 1)
        expect(page).to have_selector("input[type='radio'].tab[value='2'][checked]")
      end

      it "sets disabled state" do
        expect(page).to have_selector("input[type='radio'].tab[disabled]", count: 1)
        expect(page).to have_selector("input[type='radio'].tab[value='3'][disabled]")
      end

      it "sets ARIA attributes" do
        expect(page).to have_selector("input[type='radio'].tab[role='tab'][aria-label='Option 1']")
      end
    end
  end

  context "with custom CSS" do
    let(:tabs) { described_class.new(css: "tabs-boxed") }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "Tab 1", css: "tab-lg") { "Content 1" }
      end
    end

    describe "rendering" do
      it "includes custom container classes" do
        expect(page).to have_selector(".tabs.tabs-boxed")
      end

      it "includes custom tab classes" do
        expect(page).to have_selector(".tab.tab-lg")
      end
    end
  end

  context "with event handling" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "Click Me", html: { onclick: "alert('clicked')" })
      end
    end

    describe "rendering" do
      it "includes event handler attributes" do
        expect(page).to have_selector(".tab[onclick=\"alert('clicked')\"]")
      end
    end
  end

  context "with content wrapper customization" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "Tab", content_wrapper_css: "bg-base-100 border-base-300 rounded-box p-6") do
          "Content"
        end
      end
    end

    describe "rendering" do
      it "applies custom CSS to content wrapper" do
        expect(page).to have_selector(".tab-content.bg-base-100.border-base-300.rounded-box.p-6")
      end
    end
  end

  context "with icons in title" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab do |tab|
          tab.with_title(css: "test-tab") do
            '<div class="flex gap-x-2 items-center"><span class="size-4">icon</span><span class="whitespace-nowrap">Title</span></div>'.html_safe
          end
        end
      end
    end

    describe "rendering" do
      it "renders title with icon and proper layout" do
        expect(page).to have_selector(".tab .test-tab .flex.gap-x-2.items-center")
        expect(page).to have_selector(".tab .test-tab .size-4", text: "icon")
        expect(page).to have_selector(".tab .test-tab .whitespace-nowrap", text: "Title")
      end
    end
  end

  context "with spacer tab" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab(title: "", css: "!w-14 !cursor-auto", disabled: true)
        t.with_tab(title: "Real Tab")
      end
    end

    describe "rendering" do
      it "renders spacer tab with custom width" do
        tab = page.find(".tab[disabled]")
        expect(tab[:class]).to include("!w-14")
        expect(tab[:class]).to include("!cursor-auto")
      end

      it "renders actual tab after spacer" do
        expect(page).to have_selector(".tab", text: "Real Tab")
      end
    end
  end

  context "with turbo frame integration" do
    let(:tabs) { described_class.new }

    before do
      render_inline(tabs) do |t|
        t.with_tab(href: "?custom_tab=1", checked: true) do |tab|
          tab.with_title { "Tab 1" }
          tab.with_custom_content(css: "tab-content") { "Content 1" }
        end
        t.with_tab(href: "?custom_tab=2") do |tab|
          tab.with_title { "Tab 2" }
          tab.with_custom_content(css: "tab-content") { "Content 2" }
        end
      end
    end

    describe "rendering" do
      it "sets href for turbo navigation" do
        expect(page).to have_selector(".tab[href='?custom_tab=1']")
        expect(page).to have_selector(".tab[href='?custom_tab=2']")
      end

      it "marks the active tab" do
        expect(page).to have_selector(".tab.tab-active[href='?custom_tab=1']")
      end

      it "renders custom content with proper classes" do
        expect(page).to have_selector(".tab-content", text: "Content 1")
        expect(page).to have_selector(".tab-content", text: "Content 2")
      end
    end
  end
end
