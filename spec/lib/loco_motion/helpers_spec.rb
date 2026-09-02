# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocoMotion::Helpers do
  describe ".new_component?" do
    it "is true for a component added in the upcoming release series" do
      # Stubbed like the other cases: against the real VERSION this
      # assertion only holds while main carries a pre-release, so it broke
      # on the release commit itself (v0.8.0), where Aura's 0.7 badge
      # correctly expires.
      stub_const("LocoMotion::VERSION", "0.6.3")

      expect(described_class.new_component?("Daisy::Layout::AuraComponent")).to be true
    end

    it "is false for a component with no added metadata" do
      expect(described_class.new_component?("Daisy::Actions::ButtonComponent")).to be false
    end

    it "is false for an unknown component" do
      expect(described_class.new_component?("Nope::NopeComponent")).to be false
    end

    it "stays new while the added series is the current release" do
      stub_const("LocoMotion::VERSION", "0.7.3")

      expect(described_class.new_component?("Daisy::Layout::AuraComponent")).to be true
    end

    it "expires once the version moves past the added series" do
      stub_const("LocoMotion::VERSION", "0.8.0")

      expect(described_class.new_component?("Daisy::Layout::AuraComponent")).to be false
    end

    it "stays new on the next series' pre-release (main between releases)" do
      stub_const("LocoMotion::VERSION", "0.8.0.pre")

      expect(described_class.new_component?("Daisy::Layout::AuraComponent")).to be true
    end

    it "expires on the pre-release after the added series has shipped" do
      stub_const("LocoMotion::VERSION", "0.9.0.pre")

      expect(described_class.new_component?("Daisy::Layout::AuraComponent")).to be false
    end
  end
end
