require "rails_helper"

RSpec.describe Daisy::DataInput::FilterComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new(name: "filters"))
    expect(page).to have_css("div.filter")
  end

  it "renders reset button and options" do
    component = described_class.new(name: "filters")

    # Add reset button
    component.with_reset_button

    # Add options
    component.with_option(label: "Option 1")
    component.with_option(label: "Option 2")

    render_inline(component)

    expect(page).to have_css(".filter input[type='radio'].filter-reset") # Reset radio button
    expect(page).to have_css(".filter input[type='radio'][aria-label='Option 1']")
    expect(page).to have_css(".filter input[type='radio'][aria-label='Option 2']")
  end

  it "automatically shares the parent component's name with children" do
    component = described_class.new(name: "parent_filters")

    # Add reset button without explicitly setting name
    component.with_reset_button

    # Add option without explicitly setting name
    component.with_option(label: "Option 1")

    render_inline(component)

    # Both should inherit the name from parent
    expect(page).to have_css(".filter input[type='radio'][name='parent_filters']")
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

  context "with reset button customization" do
    it "applies custom CSS classes to the reset button" do
      component = described_class.new(name: "filters")
      component.with_reset_button(css: "btn-error")
      component.with_option(label: "Option")

      render_inline(component)

      expect(page).to have_css(".filter input[type='radio'].filter-reset.btn-error")
    end

    it "allows setting a custom value for the reset button" do
      component = described_class.new(name: "filters")
      component.with_reset_button(value: "reset_value")

      render_inline(component)

      expect(page).to have_css(".filter input[type='radio'][value='reset_value']")
    end
  end

  context "with name attribute access" do
    it "allows access to the name attribute" do
      component = described_class.new(name: "test_name")
      expect(component.name).to eq("test_name")
    end
  end

  context "with id attribute" do
    it "generates a UUID as ID if none is provided" do
      component = described_class.new(name: "test_filters")

      # The ID should be a UUID format
      expect(component.id).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
    end

    it "uses the provided ID when specified" do
      component = described_class.new(name: "test_filters", id: "custom-filter-id")
      expect(component.id).to eq("custom-filter-id")
    end

    it "gives options IDs based on parent ID and index" do
      component = described_class.new(name: "test_filters", id: "parent-filter")

      # Add options explicitly with index
      component.with_option(label: "Option 1", id: "parent-filter_0")
      component.with_option(label: "Option 2", id: "parent-filter_1")

      render_inline(component)

      # Check that each option has the expected ID
      expect(page).to have_css("input[id='parent-filter_0']")
      expect(page).to have_css("input[id='parent-filter_1']")
    end

    it "generates option IDs using the options array with indexes" do
      # Use the standard_options method which handles indexing
      component = described_class.new(
        name: "test_filters",
        id: "parent-filter",
        options: ["Option 1", "Option 2"]
      )

      render_inline(component)

      # Check that each option has automatically generated IDs with index
      expect(page).to have_css("input[id='parent-filter_0']")
      expect(page).to have_css("input[id='parent-filter_1']")
    end

    it "gives reset button an ID based on parent ID" do
      component = described_class.new(name: "test_filters", id: "parent-filter")
      component.with_reset_button

      render_inline(component)

      # Check that reset button has ID with parent ID plus '_reset'
      expect(page).to have_css("input.filter-reset[id='parent-filter_reset']")
    end

    it "gives reset button an ID based on auto-generated parent UUID" do
      component = described_class.new(name: "test_filters") # No ID provided, should auto-generate UUID
      component.with_reset_button

      render_inline(component)

      # Get the parent component's auto-generated ID
      parent_id = component.id

      # Check that the reset button has the parent's UUID plus '_reset'
      expect(page).to have_css("input.filter-reset[id='#{parent_id}_reset']")
    end
  end
end
