# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocoMotion::Icons::Reference do
  describe ".parse" do
    it "treats a bare name as default library / variant" do
      expect(described_class.parse("heart", default_library: "heroicons", default_variant: "outline"))
        .to eq(library: "heroicons", variant: "outline", name: "heart")
    end

    it "reads a library prefix" do
      expect(described_class.parse("lucide:heart", default_library: "heroicons", default_variant: "outline"))
        .to eq(library: "lucide", variant: "outline", name: "heart")
    end

    it "reads a variant suffix" do
      expect(described_class.parse("bolt/solid", default_library: "heroicons", default_variant: "outline"))
        .to eq(library: "heroicons", variant: "solid", name: "bolt")
    end

    it "reads a fully qualified token" do
      expect(described_class.parse("phosphor:gear/bold", default_library: "heroicons", default_variant: "outline"))
        .to eq(library: "phosphor", variant: "bold", name: "gear")
    end

    it "lets the token override the passed defaults" do
      result = described_class.parse("lucide:heart/duotone", default_library: "heroicons", default_variant: "outline")

      expect(result).to eq(library: "lucide", variant: "duotone", name: "heart")
    end

    it "normalizes library to a String (so refs dedupe/sort regardless of default type)" do
      from_symbol = described_class.parse("heart", default_library: :lucide, default_variant: nil)
      from_string = described_class.parse("heart", default_library: "lucide", default_variant: nil)

      expect(from_symbol).to eq(library: "lucide", variant: nil, name: "heart")
      expect(from_symbol).to eq(from_string)
    end

    it "keeps the variant's resolved type" do
      expect(described_class.parse("heart", default_variant: :outline)[:variant]).to eq(:outline)
      expect(described_class.parse("heart/solid")[:variant]).to eq("solid")
    end

    it "accepts a symbol token" do
      expect(described_class.parse(:star, default_library: "heroicons"))
        .to eq(library: "heroicons", variant: nil, name: "star")
    end
  end
end
