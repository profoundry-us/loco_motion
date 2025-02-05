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
end
