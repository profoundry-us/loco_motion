# frozen_string_literal: true

require "rails_helper"
require "loco_motion/lint/component_map"

RSpec.describe LocoMotion::Lint::ComponentMap do
  subject(:map) { described_class.build }

  it "derives a class for the large majority of registered components" do
    # The hand-maintained list this replaced covered 25 of 70 components. The
    # point of deriving it is that the number tracks the library by itself.
    expect(map.size).to be > 60
  end

  it "maps component roots to their helper, including non-obvious names" do
    expect(map["card"]).to eq("daisy_card")
    expect(map["badge"]).to eq("daisy_badge")
    # The DaisyUI class rarely matches the helper name — this is why the map is
    # read from add_css rather than inferred from the component's name.
    expect(map["btn"]).to eq("daisy_button")
  end

  it "attributes part classes to the component that owns them" do
    expect(map["card-body"]).to eq("daisy_card (body part)")
    expect(map["drawer-content"]).to eq("daisy_drawer (content_wrapper part)")
  end

  it "resolves a root declared after a nested sub-component's root" do
    # Drawer and Carousel both declare a nested root (drawer-side, carousel-item)
    # EARLIER in the file than their own, so taking the first declaration wins
    # the wrong class and leaves the component itself unenforced.
    expect(map["drawer"]).to eq("daisy_drawer")
    expect(map["carousel"]).to eq("daisy_carousel")
    expect(map["carousel-item"]).to eq("daisy_carousel (nested part)")
  end

  it "prefers the component whose registered name matches the class" do
    # Accordion and Collapse both style "collapse"; the suggestion a reader gets
    # should be the one named after it.
    expect(map["collapse"]).to eq("daisy_collapse")
  end

  it "never claims a Tailwind utility as a component class" do
    # Countdown's root is literally "flex". Claiming it would flag every .flex in
    # every view — the kind of false positive that teaches people to ignore a
    # linter altogether.
    %w[flex grid block hidden relative absolute p-4 gap-4 text-lg].each do |utility|
      expect(map).not_to have_key(utility), "#{utility} must never be flagged"
    end
  end

  describe ".unmapped" do
    # Pinned deliberately. A component landing here is NOT enforced by the
    # linter, so a new one must either declare a literal root class or be added
    # to this list on purpose — which is the whole reason the list exists.
    let(:known_unmapped) do
      [
        "Loco::IconComponent",
        "Daisy::Actions::ThemeControllerComponent",
        "Daisy::DataDisplay::CountdownComponent",
        "Daisy::DataDisplay::FigureComponent",
        "Daisy::DataInput::CallyInputComponent",
        "Daisy::DataInput::CheckboxComponent",
        "Daisy::DataInput::ToggleComponent",
        "Daisy::Navigation::PaginationComponent",
        "Daisy::Layout::MaskComponent",
        "Daisy::Mockup::DeviceComponent"
      ]
    end

    it "matches the pinned list, so new components cannot go silently unenforced" do
      expect(described_class.unmapped).to match_array(known_unmapped)
    end
  end
end
