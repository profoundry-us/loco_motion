require "rails_helper"

RSpec.describe Daisy::DataInput::CheckboxComponent, type: :component do
  it "renders a checkbox input" do
    render_inline(described_class.new(name: "accept_terms"))

    expect(page).to have_css("input[type='checkbox'][name='accept_terms']")
  end

  it "renders with a specific value" do
    render_inline(described_class.new(name: "options", value: "option1"))

    expect(page).to have_css("input[type='checkbox'][name='options'][value='option1']")
  end

  it "renders as checked when specified" do
    render_inline(described_class.new(name: "accept_terms", checked: true))

    expect(page).to have_css("input[type='checkbox'][checked]")
  end

  it "renders as a toggle when specified" do
    render_inline(described_class.new(name: "dark_mode", toggle: true))

    expect(page).to have_css("input.toggle[type='checkbox']")
    expect(page).not_to have_css("input.checkbox")
  end

  it "renders as disabled when specified" do
    render_inline(described_class.new(name: "accept_terms", disabled: true))

    expect(page).to have_css("input[type='checkbox'][disabled]")
  end

  it "renders as required when specified" do
    render_inline(described_class.new(name: "accept_terms", required: true))

    expect(page).to have_css("input[type='checkbox'][required]")
  end

  it "does not output an ID unless provided" do
    render_inline(described_class.new(name: "accept_terms"))

    expect(page).not_to have_css("input[type='checkbox'][id]")
  end

  it "uses the provided ID when specified" do
    render_inline(described_class.new(name: "accept_terms", id: "custom-id"))

    expect(page).to have_css("input[type='checkbox'][id='custom-id']")
  end
end
