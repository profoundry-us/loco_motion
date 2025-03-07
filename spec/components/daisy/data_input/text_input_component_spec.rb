require "rails_helper"

RSpec.describe Daisy::DataInput::TextInputComponent, type: :component do
  it "renders a text input" do
    render_inline(described_class.new(name: "username"))

    expect(page).to have_css("input[type='text'][name='username']")
  end

  it "renders with a specific input type when specified" do
    render_inline(described_class.new(name: "password", type: "password"))

    expect(page).to have_css("input[type='password']")
  end

  it "renders with a value when specified" do
    render_inline(described_class.new(name: "username", value: "testuser"))

    expect(page).to have_css("input[value='testuser']")
  end

  it "renders with a placeholder when specified" do
    render_inline(described_class.new(name: "email", placeholder: "Enter your email"))

    expect(page).to have_css("input[placeholder='Enter your email']")
  end

  it "renders with content in the start block" do
    render_inline(described_class.new(name: "username")) do |component|
      component.with_start { "start content" }
    end

    expect(page).to have_text("start content")
  end

  it "renders with content in the end block" do
    render_inline(described_class.new(name: "username")) do |component|
      component.with_end { "end content" }
    end

    expect(page).to have_text("end content")
  end

  it "renders with content in both start and end blocks" do
    render_inline(described_class.new(name: "username")) do |component|
      component.with_start { "start content" }
      component.with_end { "end content" }
    end

    expect(page).to have_text("start content")
    expect(page).to have_text("end content")
  end

  it "renders as disabled when specified" do
    render_inline(described_class.new(name: "username", disabled: true))

    expect(page).to have_css("input[disabled]")
  end

  it "renders as required when specified" do
    render_inline(described_class.new(name: "username", required: true))

    expect(page).to have_css("input[required]")
  end

  it "renders as readonly when specified" do
    render_inline(described_class.new(name: "username", readonly: true))

    expect(page).to have_css("input[readonly]")
  end

  it "does not output an ID unless provided" do
    render_inline(described_class.new(name: "username"))

    expect(page).not_to have_css("input[id]")
  end

  it "uses the provided ID when specified" do
    render_inline(described_class.new(name: "username", id: "custom-id"))

    expect(page).to have_css("input[id='custom-id']")
  end

  it "renders with the input CSS class" do
    render_inline(described_class.new(name: "username"))

    expect(page).to have_css("label.input")
    expect(page).to have_css("input[type='text']")
  end
end
