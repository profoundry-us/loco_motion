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

    it "preserves the default types when the token omits a part" do
      result = described_class.parse("heart", default_library: :lucide, default_variant: nil)

      expect(result).to eq(library: :lucide, variant: nil, name: "heart")
    end

    it "accepts a symbol token" do
      expect(described_class.parse(:star, default_library: "heroicons"))
        .to eq(library: "heroicons", variant: nil, name: "star")
    end
  end
end
