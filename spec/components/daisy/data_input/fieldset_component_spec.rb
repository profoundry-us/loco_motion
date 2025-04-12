# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::DataInput::FieldsetComponent, type: :component do
  it "renders with content" do
    render_inline(described_class.new) do
      "Fieldset Content"
    end

    expect(page).to have_css("fieldset", text: "Fieldset Content")
    expect(page).not_to have_css("legend.fieldset-legend")
  end

  it "renders with legend slot" do
    render_inline(described_class.new) do |c|
      c.with_legend { "My Legend Slot" }
      "Fieldset Content"
    end

    expect(page).to have_css("fieldset legend.fieldset-legend", text: "My Legend Slot")
  end

  it "renders with legend argument" do
    render_inline(described_class.new(legend: "My Simple Legend")) do
      "Fieldset Content"
    end

    expect(page).to have_css("fieldset legend.fieldset-legend", text: "My Simple Legend")
  end

  it "prioritizes legend slot over argument" do
    render_inline(described_class.new(legend: "My Simple Legend")) do |c|
      c.with_legend { "My Legend Slot" }
      "Fieldset Content"
    end

    expect(page).to have_css("fieldset legend.fieldset-legend", text: "My Legend Slot")
    expect(page).not_to have_css("fieldset legend.fieldset-legend", text: "My Simple Legend")
  end

  it "applies custom CSS classes" do
    render_inline(described_class.new(css: "my-custom-class p-4")) do
      "Fieldset Content"
    end

    expect(page).to have_css("fieldset.my-custom-class")
    expect(page).to have_css("fieldset.p-4")
  end

  it "accepts arbitrary HTML attributes" do
    render_inline(described_class.new(html: { id: "my-id", data: { foo: "test" } })) do
      "Fieldset Content"
    end

    expect(page).to have_css("fieldset[id='my-id'][data-foo='test']")
  end

  it "renders the legend part with default classes when simple legend is provided" do
    render_inline(described_class.new(legend: "Simple Part Legend")) do
      "Content"
    end
    expect(page).to have_css("legend.fieldset-legend", text: "Simple Part Legend")
  end

  it "allows customizing the legend part" do
    render_inline(described_class.new(legend: "Simple Legend")) do |fieldset|
      fieldset.with_legend(css: "custom-legend-class") { "Simple Legend" }
      "Content"
    end

    expect(page).to have_css("legend.fieldset-legend.custom-legend-class", text: "Simple Legend")
  end
end
