require "rails_helper"

RSpec.describe Daisy::DataInput::FileInputComponent, type: :component do
  it "renders a file input" do
    render_inline(described_class.new(name: "document"))

    expect(page).to have_css("input[type='file'][name='document']")
  end

  it "renders with accept attribute when specified" do
    render_inline(described_class.new(name: "image", accept: "image/*"))

    expect(page).to have_css("input[type='file'][accept='image/*']")
  end

  it "renders with multiple attribute when specified" do
    render_inline(described_class.new(name: "documents[]", multiple: true))

    expect(page).to have_css("input[type='file'][multiple]")
  end

  it "renders as disabled when specified" do
    render_inline(described_class.new(name: "document", disabled: true))

    expect(page).to have_css("input[type='file'][disabled]")
  end

  it "renders as required when specified" do
    render_inline(described_class.new(name: "document", required: true))

    expect(page).to have_css("input[type='file'][required]")
  end

  it "does not output an ID unless provided" do
    render_inline(described_class.new(name: "document"))

    expect(page).not_to have_css("input[type='file'][id]")
  end

  it "uses the provided ID when specified" do
    render_inline(described_class.new(name: "document", id: "custom-id"))

    expect(page).to have_css("input[type='file'][id='custom-id']")
  end

  it "renders with the file-input CSS class" do
    render_inline(described_class.new(name: "document"))

    expect(page).to have_css("input.file-input[type='file']")
  end
end
