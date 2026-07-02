# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::Layout::AuraComponent, type: :component do
  context "basic aura" do
    let(:aura) { described_class.new }

    before do
      render_inline(aura) do
        "Aura Content"
      end
    end

    describe "rendering" do
      it "has the aura class" do
        expect(page).to have_selector(".aura")
      end

      it "renders as a div by default" do
        expect(page).to have_selector("div.aura")
      end

      it "renders the content inside the wrapper" do
        expect(page).to have_selector(".aura", text: "Aura Content")
      end
    end
  end

  context "with content elements" do
    let(:aura) { described_class.new }

    before do
      render_inline(aura) do
        content_tag(:button, "Highlighted Action", class: "btn btn-primary")
      end
    end

    it "renders the child element inside the wrapper" do
      expect(page).to have_selector(".aura button.btn-primary", text: "Highlighted Action")
    end
  end

  context "with custom CSS" do
    let(:aura) { described_class.new(css: "aura-rainbow aura-lg text-orange-600") }

    before do
      render_inline(aura) { "Custom" }
    end

    it "applies custom CSS classes alongside the aura class" do
      expect(page).to have_selector(".aura.aura-rainbow.aura-lg.text-orange-600")
    end
  end

  context "with href" do
    let(:href) { "/pricing" }
    let(:aura) { described_class.new(href: href) }

    before do
      render_inline(aura) { "Linked" }
    end

    it "renders as an anchor tag" do
      expect(page).to have_selector("a.aura")
    end

    it "has the correct href" do
      expect(page).to have_selector("a[href='#{href}']")
    end
  end

  context "with href and target" do
    let(:href) { "https://example.com" }
    let(:aura) { described_class.new(href: href, target: "_blank") }

    before do
      render_inline(aura) { "External" }
    end

    it "applies the target attribute" do
      expect(page).to have_selector("a.aura[target='_blank'][href='#{href}']")
    end
  end

  context "with custom HTML attributes" do
    let(:aura) { described_class.new(html: { id: "my-aura", data: { test: "value" } }) }

    before do
      render_inline(aura) { "Attrs" }
    end

    it "passes attributes through to the wrapper" do
      expect(page).to have_selector(".aura#my-aura[data-test='value']")
    end
  end
end
