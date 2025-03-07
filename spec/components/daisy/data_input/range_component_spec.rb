require "rails_helper"

RSpec.describe Daisy::DataInput::RangeComponent, type: :component do
  it "renders a range input" do
    render_inline(described_class.new(name: "volume"))

    expect(page).to have_css("input[type='range'][name='volume']")
  end

  it "renders with specified min and max values" do
    render_inline(described_class.new(name: "volume", min: 10, max: 50))

    expect(page).to have_css("input[min='10'][max='50']")
  end

  it "renders with specified step value" do
    render_inline(described_class.new(name: "volume", step: 5))

    expect(page).to have_css("input[step='5']")
  end

  it "renders with specified initial value" do
    render_inline(described_class.new(name: "volume", value: 75))

    expect(page).to have_css("input[value='75']")
  end

  it "renders as disabled when specified" do
    render_inline(described_class.new(name: "volume", disabled: true))

    expect(page).to have_css("input[disabled]")
  end

  it "renders as required when specified" do
    render_inline(described_class.new(name: "volume", required: true))

    expect(page).to have_css("input[required]")
  end

  it "does not output an ID unless provided" do
    render_inline(described_class.new(name: "volume"))

    expect(page).not_to have_css("input[id]")
  end

  it "uses the provided ID when specified" do
    render_inline(described_class.new(name: "volume", id: "volume_control"))

    expect(page).to have_css("input[id='volume_control']")
  end

  it "defaults value to min when not specified" do
    render_inline(described_class.new(name: "volume", min: 10))

    expect(page).to have_css("input[value='10']")
  end
end
