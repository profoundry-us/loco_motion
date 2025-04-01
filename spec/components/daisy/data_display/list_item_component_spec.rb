require "rails_helper"

RSpec.describe Daisy::DataDisplay::ListItemComponent, type: :component do
  it "renders a basic list item" do
    render_inline(described_class.new) { "Basic item" }

    expect(page).to have_css(".list-row")
    expect(page).to have_content("Basic item")
  end

  it "applies custom CSS classes" do
    render_inline(described_class.new(css: "my-custom-class")) { "Styled item" }

    expect(page).to have_css(".list-row.my-custom-class")
  end
end
