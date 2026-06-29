# frozen_string_literal: true

require "rails_helper"

RSpec.describe Loco::IconComponent, type: :component do
  context "with a positional icon name" do
    before { render_inline(described_class.new("academic-cap")) }

    it "renders an inline svg" do
      expect(page).to have_css("svg")
    end

    it "applies the default where:size-5 class" do
      expect(page).to have_css('svg[class*="where:size-5"]')
    end
  end

  context "with the icon as a keyword argument" do
    before { render_inline(described_class.new(icon: "beaker")) }

    it "renders an inline svg" do
      expect(page).to have_css("svg")
    end
  end

  context "with a custom size class" do
    before { render_inline(described_class.new("academic-cap", css: "size-8 text-red-500")) }

    it "uses the provided size instead of the default" do
      expect(page).to have_css('svg[class*="size-8"]')
      expect(page).not_to have_css('svg[class*="where:size-5"]')
    end
  end

  context "with a variant" do
    it "renders the solid variant" do
      render_inline(described_class.new("bolt", variant: :solid))

      expect(page).to have_css("svg")
      expect(page.native.to_html).to include('fill="currentColor"')
    end
  end

  context "with a tooltip" do
    before { render_inline(described_class.new("academic-cap", tip: "Helpful")) }

    it "adds the tooltip class and data-tip attribute" do
      expect(page).to have_css("svg.tooltip")
      expect(page).to have_css('svg[data-tip="Helpful"]')
    end
  end

  context "with an unbundled library" do
    it "raises a clear error" do
      expect do
        render_inline(described_class.new("heart", library: :not_installed))
      end.to raise_error(LocoMotion::Icons::IconNotFound)
    end
  end
end
