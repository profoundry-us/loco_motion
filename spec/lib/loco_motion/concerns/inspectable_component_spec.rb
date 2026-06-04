# frozen_string_literal: true

require "rails_helper"

# Test class that includes the concern
class InspectableTestClass
  include LocoMotion::Concerns::InspectableComponent

  attr_reader :name, :value, :options

  def initialize(name:, value:, options: {})
    @name = name
    @value = value
    @options = options
  end

  def inspect
    build_inspect_string("name", "value", "options")
  end
end

# Test class that uses custom suffix
class InspectableTestClassWithSuffix
  include LocoMotion::Concerns::InspectableComponent

  attr_reader :data

  def initialize(data:)
    @data = data
  end

  def inspect
    build_inspect_string("data", suffix: "]")
  end
end

RSpec.describe LocoMotion::Concerns::InspectableComponent, type: :lib do
  context "with default suffix" do
    let(:instance) { InspectableTestClass.new(name: "test", value: 123, options: { a: 1 }) }

    it "builds inspect string with default '>' suffix" do
      expect(instance.inspect).to include(">")
      expect(instance.inspect).to include("@name=\"test\"")
      expect(instance.inspect).to include("@value=123")
      expect(instance.inspect).to include("@options={a: 1}")
    end

    it "includes class name in inspect string" do
      expect(instance.inspect).to start_with("#<InspectableTestClass")
    end

    it "formats attributes with @ prefix" do
      expect(instance.inspect).to match(/@\w+=/)
    end
  end

  context "with custom suffix" do
    let(:instance) { InspectableTestClassWithSuffix.new(data: "custom") }

    it "builds inspect string with custom suffix" do
      expect(instance.inspect).to end_with("]")
      expect(instance.inspect).to include("@data=\"custom\"")
    end

    it "does not include default '>' suffix" do
      expect(instance.inspect).not_to include(">")
    end
  end

  context "with no attributes" do
    let(:instance) { InspectableTestClass.new(name: "empty", value: nil, options: {}) }

    it "builds inspect string with no attributes" do
      expect(instance.inspect).to eq("#<InspectableTestClass @name=\"empty\" @value=nil @options={}>")
    end
  end

  context "with complex attribute values" do
    let(:instance) do
      InspectableTestClass.new(
        name: "complex",
        value: [1, 2, 3],
        options: { nested: { key: "value" }, array: [1, 2, 3] }
      )
    end

    it "properly inspects complex data structures" do
      expect(instance.inspect).to include("@value=[1, 2, 3]")
      expect(instance.inspect).to include("@options={nested: {key: \"value\"}, array: [1, 2, 3]}")
    end
  end
end
