# frozen_string_literal: true

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

  it "renders with a string start label" do
    render_inline(described_class.new(name: "option", value: "1", start: "Option:"))

    expect(page).to have_css("label")
    expect(page).to have_css("span", text: "Option:")
  end

  it "renders with a string end label" do
    render_inline(described_class.new(name: "option", value: "1", end: "Option 1"))

    expect(page).to have_css("label")
    expect(page).to have_css("span", text: "Option 1")
  end

  it "renders with content in the start block" do
    render_inline(described_class.new(name: "option", value: "1")) do |component|
      component.with_start { "Start content" }
    end

    expect(page).to have_css("label")
    expect(page).to have_text("Start content")
  end

  it "renders with content in the end block" do
    render_inline(described_class.new(name: "option", value: "1")) do |component|
      component.with_end { "End content" }
    end

    expect(page).to have_css("label")
    expect(page).to have_text("End content")
  end

  it "properly adds CSS classes when using labels" do
    render_inline(described_class.new(name: "option", value: "1", end: "Option 1"))

    expect(page).to have_css("label")
    expect(page).to have_css("input[type='radio']")
  end

  it "adds 'label' CSS class to label_wrapper when using labels" do
    render_inline(described_class.new(name: "option", value: "1", end: "Option 1"))

    expect(page).to have_css("label.label")
  end

  it "does not add 'label' CSS class when no labels are used" do
    render_inline(described_class.new(name: "option", value: "1"))

    expect(page).not_to have_css("label.label")
    expect(page).not_to have_css("label")
  end
end
