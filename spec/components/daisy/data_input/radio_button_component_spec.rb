require "rails_helper"

RSpec.describe Daisy::DataInput::RadioButtonComponent, type: :component do
  it "renders a radio button input" do
    render_inline(described_class.new(name: "option", value: "1"))

    expect(page).to have_css("input[type='radio'][name='option'][value='1']")
  end

  it "renders with a specific value" do
    render_inline(described_class.new(name: "option", value: "option1"))

    expect(page).to have_css("input[type='radio'][name='option'][value='option1']")
  end

  it "renders as checked when specified" do
    render_inline(described_class.new(name: "option", value: "1", checked: true))

    expect(page).to have_css("input[type='radio'][checked]")
  end

  it "renders as disabled when specified" do
    render_inline(described_class.new(name: "option", value: "1", disabled: true))

    expect(page).to have_css("input[type='radio'][disabled]")
  end

  it "renders as required when specified" do
    render_inline(described_class.new(name: "option", value: "1", required: true))

    expect(page).to have_css("input[type='radio'][required]")
  end

  it "does not output an ID unless provided" do
    render_inline(described_class.new(name: "option", value: "1"))

    expect(page).not_to have_css("input[type='radio'][id]")
  end

  it "uses the provided ID when specified" do
    render_inline(described_class.new(name: "option", value: "1", id: "custom-id"))

    expect(page).to have_css("input[type='radio'][id='custom-id']")
  end
end
