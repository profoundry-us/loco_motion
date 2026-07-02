# frozen_string_literal: true

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

  it "renders with a string start label" do
    render_inline(described_class.new(name: "notifications", leading: "Enable:"))

    expect(page).to have_css("label")
    expect(page).to have_css("span", text: "Enable:")
  end

  it "renders with a string end label" do
    render_inline(described_class.new(name: "notifications", trailing: "Enable notifications"))

    expect(page).to have_css("label")
    expect(page).to have_css("span", text: "Enable notifications")
  end

  it "renders with content in the leading block" do
    render_inline(described_class.new(name: "notifications")) do |component|
      component.with_leading { "Leading content" }
    end

    expect(page).to have_css("label")
    expect(page).to have_text("Leading content")
  end

  it "renders with content in the trailing block" do
    render_inline(described_class.new(name: "notifications")) do |component|
      component.with_trailing { "Trailing content" }
    end

    expect(page).to have_css("label")
    expect(page).to have_text("Trailing content")
  end

  it "properly adds CSS classes when using labels" do
    render_inline(described_class.new(name: "notifications", trailing: "Enable notifications"))

    # The label and input structure is different when using labels
    expect(page).to have_css("label")
    expect(page).to have_css("input[type='checkbox']")
  end

  it "renders the companion hidden field before the toggle (inherited)" do
    render_inline(described_class.new(name: "notifications"))

    expect(page).to have_css(
      "input[type='hidden'][name='notifications'][value='0'] + input.toggle",
      visible: :all
    )
  end

  it "omits the hidden field when include_hidden is false" do
    render_inline(described_class.new(name: "notifications", include_hidden: false))

    expect(page).not_to have_css("input[type='hidden']", visible: :all)
  end
end
