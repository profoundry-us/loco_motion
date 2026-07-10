# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocoMotion::Helpers do
  describe ".new_component?" do
    it "is true for a component added in the upcoming release series" do
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
  end
end
