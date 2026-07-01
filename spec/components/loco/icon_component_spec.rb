# frozen_string_literal: true

require "rails_helper"

RSpec.describe Loco::IconComponent, type: :component do
  context "with a positional icon name" do
    before { render_inline(described_class.new("x-mark")) }

    it "renders an inline svg" do
      expect(page).to have_css("svg")
    end

    it "applies the default where:size-5 class" do
      expect(page).to have_css('svg[class*="where:size-5"]')
    end
  end

  context "with the icon as a keyword argument" do
    before { render_inline(described_class.new(icon: "check")) }

    it "renders an inline svg" do
      expect(page).to have_css("svg")
    end
  end

  context "with a custom size class" do
    before { render_inline(described_class.new("x-mark", css: "size-8 text-red-500")) }

    it "uses the provided size instead of the default" do
      expect(page).to have_css('svg[class*="size-8"]')
      expect(page).not_to have_css('svg[class*="where:size-5"]')
    end
  end

  context "with a variant in the token" do
    it "renders the solid variant" do
      render_inline(described_class.new("x-mark/solid"))

      expect(page).to have_css("svg")
      expect(page.native.to_html).to include('fill="currentColor"')
    end
  end

  context "when passed a library: or variant: option" do
    it "raises, pointing at the token form" do
      expect { described_class.new("bolt", variant: :solid) }
        .to raise_error(ArgumentError, /token/)
      expect { described_class.new("heart", library: :lucide) }
        .to raise_error(ArgumentError, /token/)
    end
  end

  context "with a tooltip" do
    before { render_inline(described_class.new("x-mark", tip: "Close")) }

    it "adds the tooltip class and data-tip attribute" do
      expect(page).to have_css("svg.tooltip")
      expect(page).to have_css('svg[data-tip="Close"]')
    end
  end

  context "with an unbundled library" do
    it "raises a clear error" do
      expect do
        render_inline(described_class.new("not_installed:heart"))
      end.to raise_error(LocoMotion::Icons::IconNotFound)
    end
  end

  context "with a configured default variant" do
    around do |example|
      original = LocoMotion.configuration.default_icon_variant
      LocoMotion.configuration.default_icon_variant = :solid
      example.run
      LocoMotion.configuration.default_icon_variant = original
    end

    it "uses the configured default when no variant is given" do
      render_inline(described_class.new("x-mark"))

      expect(page.native.to_html).to include('fill="currentColor"') # solid
    end

    it "still lets a token variant win" do
      render_inline(described_class.new("x-mark/outline"))

      expect(page.native.to_html).to include('fill="none"') # outline
    end
  end
end
