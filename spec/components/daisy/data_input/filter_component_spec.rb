require "rails_helper"

RSpec.describe Daisy::DataInput::FilterComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new(name: "filters"))
    expect(page).to have_css("div.filter")
  end

  it "renders reset button and options" do
    component = described_class.new(name: "filters")

    # Add reset button with value
    component.with_reset_button(value: "x")

    # Add options
    component.with_option(name: "filters", label: "Option 1")
    component.with_option(name: "filters", label: "Option 2")

    render_inline(component)

    expect(page).to have_css(".filter button.btn.filter-button-reset") # Button reset
    expect(page).to have_css(".filter input[type='radio'][value='x']") # Check for value attribute
    expect(page).to have_css(".filter input[type='radio'][aria-label='Option 1']")
    expect(page).to have_css(".filter input[type='radio'][aria-label='Option 2']")
  end

  context "with custom HTML attributes" do
    it "passes attributes to the component" do
      render_inline(described_class.new(
        name: "filters",
        html: { id: "custom-filter", data: { test: "value" } }
      ))

      expect(page).to have_css("div#custom-filter")
      expect(page).to have_css("div[data-test='value']")
    end
  end

  context "with options parameter" do
    it "renders options from array" do
      render_inline(described_class.new(
        name: "filters",
        options: ["Option A", "Option B", "Option C"]
      ))

      expect(page).to have_css(".filter input[type='radio'][aria-label='Option A']")
      expect(page).to have_css(".filter input[type='radio'][aria-label='Option B']")
      expect(page).to have_css(".filter input[type='radio'][aria-label='Option C']")
    end

    it "renders options from hash with labels" do
      render_inline(described_class.new(
        name: "filters",
        options: [
          { label: "Custom Label 1", value: "value1" },
          { label: "Custom Label 2", value: "value2" }
        ]
      ))

      expect(page).to have_css(".filter input[type='radio'][aria-label='Custom Label 1'][value='value1']")
      expect(page).to have_css(".filter input[type='radio'][aria-label='Custom Label 2'][value='value2']")
    end
  end

  context "with filter-reset option" do
    it "applies the filter-reset class to the option" do
      component = described_class.new(name: "filters")
      component.with_option(name: "filters", label: "All", css: "filter-reset")

      render_inline(component)

      expect(page).to have_css(".filter input[type='radio'].filter-reset")
    end
  end

  context "with reset button customization" do
    it "applies custom CSS classes to the reset button" do
      component = described_class.new(name: "filters")
      component.with_reset_button(value: "x", css: "btn-error")
      component.with_option(name: "filters", label: "Option")

      render_inline(component)

      expect(page).to have_css(".filter button.btn.filter-button-reset.btn-error")
      expect(page).to have_css(".filter input[type='radio'][value='x']")
    end
  end
end
