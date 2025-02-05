require "rails_helper"

RSpec.describe Daisy::DataDisplay::CollapseComponent, type: :component do
  it "renders a collapse with a custom title block" do
    result = render_inline(described_class.new) do |c|
      c.with_title do
        "Custom Title"
      end

      "Content"
    end

    expect(result.to_html).to include("Custom Title")
    expect(result.to_html).to include("Content")
  end

  it "renders a collapse with a simple title" do
    result = render_inline(described_class.new(title: "Simple Title")) do
      "Content"
    end

    expect(result.to_html).to include("Simple Title")
    expect(result.to_html).to include("Content")
  end

  it "renders a collapse with a checkbox" do
    result = render_inline(described_class.new(checkbox: true)) do
      "Content"
    end

    expect(result.to_html).to include("<input type=\"checkbox\">")
    expect(result.to_html).to include("Content")
  end

  it "renders a collapse with custom styling" do
    result = render_inline(described_class.new(css: "bg-base-200")) do |c|
      c.with_title do
        "Custom Title"
      end

      "Content"
    end

    expect(result.to_html).to include("bg-base-200")
    expect(result.to_html).to include("Custom Title")
    expect(result.to_html).to include("Content")
  end

  it "renders a collapse with a custom wrapper class" do
    result = render_inline(described_class.new(wrapper_css: "bg-base-200")) do
      "Content"
    end

    expect(result.to_html).to include("bg-base-200")
    expect(result.to_html).to include("Content")
  end

  it "handles missing title gracefully" do
    result = render_inline(described_class.new) do
      "Content"
    end

    expect(result.to_html).to include("Content")
  end
end
