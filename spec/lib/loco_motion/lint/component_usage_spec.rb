# frozen_string_literal: true

require "rails_helper"
require "haml_lint"
require "loco_motion/lint/haml_lint/component_usage"

RSpec.describe HamlLint::Linter::LocoMotionComponentUsage do
  def lints_for(haml)
    config = HamlLint::ConfigurationLoader.default_configuration
    # .dup because haml_lint force_encodings the source in place, and this file
    # is frozen_string_literal.
    document = HamlLint::Document.new(haml.dup, config: config, file: "example.html.haml")
    linter = described_class.new(config.for_linter("LocoMotionComponentUsage"))
    linter.run(document)
    linter.lints.map(&:message)
  end

  it "flags a hand-rolled component class and names the helper to use" do
    expect(lints_for(".card\n")).to contain_exactly(a_string_including("daisy_card"))
  end

  it "reads classes from the attributes hash as well as the shorthand" do
    # Both spellings appear in real views; catching only one would make the rule
    # trivially avoidable.
    expect(lints_for("%div{ class: \"btn\" }\n")).to contain_exactly(a_string_including("daisy_button"))
  end

  it "ignores Tailwind utilities and DaisyUI modifiers" do
    # btn-primary modifies a button; on its own it is not hand-rolled markup, and
    # css: is the sanctioned way to pass it to the helper.
    expect(lints_for(".flex.gap-4.p-4.text-lg\n")).to be_empty
    expect(lints_for("%span.badge-success\n")).to be_empty
  end

  it "reports each offending class on a tag once" do
    lints = lints_for(".card.card.bg-base-100\n")
    expect(lints.size).to eq(1)
  end

  it "leaves dynamic class values alone" do
    # A computed class is not something this rule can judge, and guessing would
    # produce exactly the false positives that get linters switched off.
    expect(lints_for("%div{ class: some_helper_method }\n")).to be_empty
  end

  it "says what to do, not merely what is wrong" do
    expect(lints_for(".drawer\n").first).to include("daisy_drawer", "call the helper")
  end
end
