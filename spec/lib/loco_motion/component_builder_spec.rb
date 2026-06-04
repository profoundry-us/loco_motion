# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocoMotion::ComponentBuilder do
  let(:base_class) { LocoMotion::BaseComponent }
  let(:build_kws) { { css: "custom-class", skip_styling: true } }
  let(:build_block) { nil }

  describe "#initialize" do
    it "initializes with base class and build keywords" do
      builder = described_class.new(base_class, build_kws)
      expect(builder.base_class).to eq(base_class)
      expect(builder.build_kws).to eq(build_kws)
    end

    it "initializes with empty build keywords by default" do
      builder = described_class.new(base_class)
      expect(builder.build_kws).to eq({})
    end

    it "stores the build block when provided" do
      test_block = proc { puts "test" }
      builder = described_class.new(base_class, build_kws, &test_block)
      expect(builder.build_block).to eq(test_block)
    end
  end

  describe "#build" do
    it "creates a subclass of the base class" do
      builder = described_class.new(base_class)
      klass = builder.build
      expect(klass).to be < base_class
    end

    it "creates a named subclass with a unique name" do
      builder1 = described_class.new(base_class)
      klass1 = builder1.build

      builder2 = described_class.new(base_class)
      klass2 = builder2.build

      expect(klass1.name).to include("Build")
      expect(klass2.name).to include("Build")
      expect(klass1.name).not_to eq(klass2.name)
    end

    it "increments the build counter on the base class" do
      initial_counter = base_class.instance_variable_get(:@build_counter) || 0

      builder1 = described_class.new(base_class)
      builder1.build

      builder2 = described_class.new(base_class)
      builder2.build

      final_counter = base_class.instance_variable_get(:@build_counter)
      expect(final_counter).to be >= initial_counter
    end

    it "merges build keywords into the component config" do
      builder = described_class.new(base_class, css: "test-class")
      klass = builder.build
      instance = klass.new

      expect(instance.config.parts[:component][:user_css]).to include("test-class")
    end

    it "sets instance variables from build keywords" do
      builder = described_class.new(base_class, skip_styling: true)
      klass = builder.build
      instance = klass.new

      expect(instance.instance_variable_get(:@skip_styling)).to be true
    end

    it "applies customizations from the build block" do
      custom_method_added = false

      builder = described_class.new(base_class) do
        define_method(:custom_method) do
          "custom"
        end
        custom_method_added = true
      end

      builder.build
      expect(custom_method_added).to be true
    end

    it "preserves component_name from the base class" do
      base_class.instance_variable_set(:@component_name, "test_component")

      builder = described_class.new(base_class)
      klass = builder.build

      expect(klass.instance_variable_get(:@component_name)).to eq("test_component")

      # Clean up
      base_class.instance_variable_set(:@component_name, nil)
    end

    context "when base class does not have component_name" do
      it "does not set component_name on subclass" do
        base_class.remove_instance_variable(:@component_name) if base_class.instance_variable_defined?(:@component_name)

        builder = described_class.new(base_class)
        klass = builder.build

        expect(klass.instance_variable_get(:@component_name)).to be_nil
      end
    end

    context "when build keywords are empty" do
      it "still creates a valid subclass" do
        builder = described_class.new(base_class)
        klass = builder.build

        expect(klass).to be < base_class
        expect(klass.name).to include("Build")
      end
    end

    context "when no build block is provided" do
      it "still creates a valid subclass" do
        builder = described_class.new(base_class, css: "test")
        klass = builder.build

        expect(klass).to be < base_class
        expect(klass.name).to include("Build")
      end
    end
  end

  describe "integration with BaseComponent.build" do
    it "works as a drop-in replacement for the original implementation" do
      # Test that the BaseComponent.build method still works
      klass = base_class.build(css: "integration-test", skip_styling: true)
      instance = klass.new

      expect(klass).to be < base_class
      expect(instance.config.parts[:component][:user_css]).to include("integration-test")
      expect(instance.instance_variable_get(:@skip_styling)).to be true
    end

    it "handles complex build scenarios with blocks" do
      klass = base_class.build(css: "complex") do
        define_method(:custom_behavior) do
          "custom"
        end
      end

      instance = klass.new
      expect(instance.respond_to?(:custom_behavior)).to be true
    end
  end
end
