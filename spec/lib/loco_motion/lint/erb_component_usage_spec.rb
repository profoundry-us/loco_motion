# frozen_string_literal: true

require "rails_helper"
require "erb_lint/all"
require "loco_motion/lint/erb_lint/component_usage"

RSpec.describe ERBLint::Linters::LocoMotionComponentUsage do
  def offenses_for(erb)
    linter = described_class.new(
      ERBLint::FileLoader.new(Dir.pwd),
      described_class.config_schema.new
    )
    linter.run(ERBLint::ProcessedSource.new("example.html.erb", erb))
    linter.offenses.map(&:message)
  end

  it "flags a hand-rolled component class and names the helper to use" do
    expect(offenses_for('<div class="card"></div>'))
      .to contain_exactly(a_string_including("daisy_card"))
  end

  it "reads every class on the attribute, not just the first" do
    expect(offenses_for('<div class="shadow card"></div>'))
      .to contain_exactly(a_string_including("daisy_card"))
  end

  it "ignores Tailwind utilities and DaisyUI modifiers" do
    # css: is the sanctioned way to pass a modifier to a helper, so a modifier
    # on its own is not hand-rolled markup.
    expect(offenses_for('<div class="flex gap-4 p-4 bg-base-100"></div>')).to be_empty
    expect(offenses_for('<span class="badge-success"></span>')).to be_empty
  end

  it "leaves computed class values alone" do
    # Guessing at an interpolated class is how a linter earns a reputation for
    # false positives and gets switched off.
    expect(offenses_for('<div class="<%= card_classes %>"></div>')).to be_empty
  end

  it "enforces the same map as the HAML linter" do
    # The two template languages must not drift into different rules — that was
    # the practical failure of the hand-written list these replace.
    require "loco_motion/lint/component_map"
    map = LocoMotion::Lint::ComponentMap.build

    expect(offenses_for('<div class="drawer"></div>').first).to include(map["drawer"])
    expect(offenses_for('<div class="carousel-item"></div>').first).to include("daisy_carousel")
  end
end
