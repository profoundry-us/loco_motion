# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::DataInput::SelectComponent, type: :component do
  it "renders a select component with default options" do
    options = [
      { value: "option1", label: "Option 1" },
      { value: "option2", label: "Option 2" }
    ]

    component = described_class.new(name: "test", id: "test", options: options)
    render_inline(component)

    expect(page).to have_css("select.select")
    expect(page).to have_css("select[name='test']")
    expect(page).to have_css("select[id='test']")
    expect(page).to have_css("option[value='option1']", text: "Option 1")
    expect(page).to have_css("option[value='option2']", text: "Option 2")
  end

  it "renders a select component with a placeholder" do
    component = described_class.new(name: "test", id: "test", placeholder: "Select an option")
    render_inline(component)

    expect(page).to have_css("option[value=''][disabled][selected]", text: "Select an option")
  end

  it "renders a select component with a selected option" do
    options = [
      { value: "option1", label: "Option 1" },
      { value: "option2", label: "Option 2" }
    ]

    component = described_class.new(name: "test", id: "test", options: options, value: "option2")
    render_inline(component)

    expect(page).to have_css("option[value='option1']:not([selected])")
    expect(page).to have_css("option[value='option2'][selected]")
  end

  it "renders a disabled select component" do
    component = described_class.new(name: "test", id: "test", disabled: true)
    render_inline(component)

    expect(page).to have_css("select[disabled]")
  end

  it "renders a required select component" do
    component = described_class.new(name: "test", id: "test", required: true)
    render_inline(component)

    expect(page).to have_css("select[required]")
  end

  it "renders a select component with custom CSS classes" do
    component = described_class.new(name: "test", id: "test", css: "select-primary select-lg")
    render_inline(component)

    expect(page).to have_css("select.select-primary.select-lg")
  end

  it "renders a select component with options from a block" do
    component = described_class.new(name: "test", id: "test")
    render_inline(component) do |c|
      c.with_option(value: "option1", label: "Option 1")
      c.with_option(value: "option2", label: "Option 2")
    end

    expect(page).to have_css("option[value='option1']", text: "Option 1")
    expect(page).to have_css("option[value='option2']", text: "Option 2")
  end

  it "renders a select component with options_css applied to each option" do
    options = ["Option 1", "Option 2"]
    component = described_class.new(name: "test", id: "test", options: options, options_css: "text-primary")
    render_inline(component)

    expect(page).to have_css("option.text-primary", count: 2)
  end

  it "renders a select component with options_html applied to each option" do
    options = ["Option 1", "Option 2"]
    component = described_class.new(
      name: "test",
      id: "test",
      options: options,
      options_html: { data: { test: "value" } }
    )
    render_inline(component)

    expect(page).to have_css("option[data-test='value']", count: 2)
  end

  it "renders a select component with simple string options" do
    options = ["Option 1", "Option 2"]
    component = described_class.new(name: "test", id: "test", options: options)
    render_inline(component)

    expect(page).to have_css("option[value='Option 1']", text: "Option 1")
    expect(page).to have_css("option[value='Option 2']", text: "Option 2")
  end

  it "renders a select component with a single option" do
    component = described_class.new(name: "test", id: "test", options: "Single Option")
    render_inline(component)

    expect(page).to have_css("option", count: 1)
    expect(page).to have_css("option[value='Single Option']", text: "Single Option")
  end

end
