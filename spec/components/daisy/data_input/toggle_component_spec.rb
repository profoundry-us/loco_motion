require "rails_helper"

RSpec.describe Daisy::DataInput::ToggleComponent, type: :component do
  it "renders a toggle input" do
    render_inline(described_class.new(name: "notifications"))

    expect(page).to have_css("input[type='checkbox'][name='notifications']")
    expect(page).to have_css("input.toggle")
    expect(page).not_to have_css("input.checkbox")
  end

  it "renders with a specific value" do
    render_inline(described_class.new(name: "settings", value: "dark_mode"))

    expect(page).to have_css("input[type='checkbox'][name='settings'][value='dark_mode']")
    expect(page).to have_css("input.toggle")
  end

  it "renders as checked when specified" do
    render_inline(described_class.new(name: "notifications", checked: true))

    expect(page).to have_css("input[type='checkbox'][checked]")
    expect(page).to have_css("input.toggle")
  end

  it "always renders as a toggle and ignores toggle:false if specified" do
    render_inline(described_class.new(name: "theme", toggle: false))

    expect(page).to have_css("input.toggle[type='checkbox']")
    expect(page).not_to have_css("input.checkbox")
  end

  it "renders with color class when specified in css" do
    render_inline(described_class.new(name: "theme", css: "toggle-primary"))

    expect(page).to have_css("input.toggle[type='checkbox']")
    expect(page).to have_css("input.toggle-primary")
  end

  it "renders as disabled when specified" do
    render_inline(described_class.new(name: "notifications", disabled: true))

    expect(page).to have_css("input[type='checkbox'][disabled]")
    expect(page).to have_css("input.toggle")
  end

  it "renders as required when specified" do
    render_inline(described_class.new(name: "terms", required: true))

    expect(page).to have_css("input[type='checkbox'][required]")
    expect(page).to have_css("input.toggle")
  end

  it "does not output an ID unless provided" do
    render_inline(described_class.new(name: "notifications"))

    expect(page).not_to have_css("input[type='checkbox'][id]")
    expect(page).to have_css("input.toggle")
  end

  it "uses the provided ID when specified" do
    render_inline(described_class.new(name: "notifications", id: "notif-toggle"))

    expect(page).to have_css("input[type='checkbox'][id='notif-toggle']")
    expect(page).to have_css("input.toggle")
  end
end
