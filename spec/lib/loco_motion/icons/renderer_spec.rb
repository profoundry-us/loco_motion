# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "fileutils"

RSpec.describe LocoMotion::Icons::Renderer do
  describe "#to_svg" do
    it "renders a bundled Heroicon as inline SVG" do
      svg = described_class.new(name: "academic-cap").to_svg

      expect(svg).to start_with("<svg")
      expect(svg).to include("</svg>")
      expect(svg).to include("<path")
    end

    it "preserves the case-sensitive viewBox attribute (XML mode, not HTML)" do
      svg = described_class.new(name: "academic-cap").to_svg

      expect(svg).to include('viewBox="0 0 24 24"')
      expect(svg).not_to include("viewbox=")
    end

    it "inherits color via currentColor" do
      expect(described_class.new(name: "academic-cap").to_svg).to include("currentColor")
    end

    it "defaults to the heroicons outline variant" do
      outline = described_class.new(name: "bolt").to_svg
      solid = described_class.new(name: "bolt", variant: :solid).to_svg

      expect(outline).to include('fill="none"')          # outline is stroked
      expect(solid).to include('fill="currentColor"')    # solid is filled
      expect(outline).not_to eq(solid)
    end

    it "applies (and merges) the class attribute" do
      svg = described_class.new(
        name: "academic-cap", attributes: { class: "size-8 text-red-500" }
      ).to_svg

      expect(svg).to include("size-8")
      expect(svg).to include("text-red-500")
    end

    it "expands data and aria hashes into prefixed attributes" do
      svg = described_class.new(
        name: "academic-cap",
        attributes: { data: { tip: "Hello", controller: "swap" }, aria: { label: "Cap" } }
      ).to_svg

      expect(svg).to include('data-tip="Hello"')
      expect(svg).to include('data-controller="swap"')
      expect(svg).to include('aria-label="Cap"')
    end

    it "raises a clear error when the icon cannot be found" do
      expect do
        described_class.new(name: "definitely-not-an-icon").to_svg
      end.to raise_error(LocoMotion::Icons::IconNotFound, /definitely-not-an-icon/)
    end

    context "with two-tier resolution" do
      let(:app_root) { Dir.mktmpdir }

      before do
        dir = File.join(app_root, "app/assets/svg/icons/heroicons/outline")
        FileUtils.mkdir_p(dir)
        File.write(
          File.join(dir, "academic-cap.svg"),
          %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" ) +
            %(data-source="app-override"><path d="M0 0"/></svg>)
        )
        allow_any_instance_of(described_class)
          .to receive(:application_root).and_return(app_root)
      end

      after { FileUtils.remove_entry(app_root) }

      it "prefers an app-synced icon over the bundled one" do
        svg = described_class.new(name: "academic-cap").to_svg

        expect(svg).to include('data-source="app-override"')
      end

      it "falls back to the bundled icon when the app does not provide it" do
        svg = described_class.new(name: "beaker").to_svg

        expect(svg).to start_with("<svg")
        expect(svg).not_to include("app-override")
      end
    end
  end
end
