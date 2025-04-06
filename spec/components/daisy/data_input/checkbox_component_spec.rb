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

  it "renders with a string start label" do
    render_inline(described_class.new(name: "accept_terms", start: "Accept:"))

    expect(page).to have_css("label")
    expect(page).to have_css("span", text: "Accept:")
  end

  it "renders with a string end label" do
    render_inline(described_class.new(name: "accept_terms", end: "I accept the terms"))

    expect(page).to have_css("label")
    expect(page).to have_css("span", text: "I accept the terms")
  end

  it "renders with content in the start block" do
    render_inline(described_class.new(name: "accept_terms")) do |component|
      component.with_start { "Start content" }
    end

    expect(page).to have_css("label")
    expect(page).to have_text("Start content")
  end

  it "renders with content in the end block" do
    render_inline(described_class.new(name: "accept_terms")) do |component|
      component.with_end { "End content" }
    end

    expect(page).to have_css("label")
    expect(page).to have_text("End content")
  end

  it "properly adds CSS classes when using labels" do
    render_inline(described_class.new(name: "accept_terms", end: "I accept the terms"))

    # The label and input structure is different when using labels
    expect(page).to have_css("label")
    expect(page).to have_css("input[type='checkbox']")
  end

  it "adds 'label' CSS class to label_wrapper when using labels" do
    render_inline(described_class.new(name: "accept_terms", end: "I accept the terms"))

    # Verify the label CSS class is added to the label_wrapper
    expect(page).to have_css("label.label")
  end

  it "does not add 'label' CSS class when no labels are used" do
    render_inline(described_class.new(name: "accept_terms"))

    # Verify no label element is present when no labels are used
    expect(page).not_to have_css("label.label")
    expect(page).not_to have_css("label")
  end
end
