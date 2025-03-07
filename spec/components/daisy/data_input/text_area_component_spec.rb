require "rails_helper"

RSpec.describe Daisy::DataInput::TextAreaComponent, type: :component do
  it "renders a textarea" do
    render_inline(described_class.new(name: "message"))

    expect(page).to have_css("textarea[name='message']")
  end

  it "renders with placeholder when specified" do
    render_inline(described_class.new(name: "message", placeholder: "Enter your message here..."))

    expect(page).to have_css("textarea[placeholder='Enter your message here...']")
  end

  it "renders with rows attribute when specified" do
    render_inline(described_class.new(name: "message", rows: 6))

    expect(page).to have_css("textarea[rows='6']")
  end

  it "renders with cols attribute when specified" do
    render_inline(described_class.new(name: "message", cols: 40))

    expect(page).to have_css("textarea[cols='40']")
  end

  it "renders with value when provided" do
    render_inline(described_class.new(name: "message", value: "Initial text content"))

    expect(page).to have_css("textarea", text: "Initial text content")
  end

  it "renders as disabled when specified" do
    render_inline(described_class.new(name: "message", disabled: true))

    expect(page).to have_css("textarea[disabled]")
  end

  it "renders as required when specified" do
    render_inline(described_class.new(name: "message", required: true))

    expect(page).to have_css("textarea[required]")
  end

  it "renders as readonly when specified" do
    render_inline(described_class.new(name: "message", readonly: true))

    expect(page).to have_css("textarea[readonly]")
  end

  it "does not output an ID unless provided" do
    render_inline(described_class.new(name: "message"))

    expect(page).not_to have_css("textarea[id]")
  end

  it "uses the provided ID when specified" do
    render_inline(described_class.new(name: "message", id: "custom-id"))

    expect(page).to have_css("textarea[id='custom-id']")
  end

  it "renders with the textarea CSS class" do
    render_inline(described_class.new(name: "message"))

    expect(page).to have_css("textarea.textarea")
  end
end
