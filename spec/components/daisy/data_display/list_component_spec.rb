require "rails_helper"

RSpec.describe Daisy::DataDisplay::ListComponent, type: :component do
  it "renders a list with basic content" do
    render_inline(described_class.new) do |list|
      list.with_item { "Item 1" }
      list.with_item { "Item 2" }
    end

    expect(page).to have_css("ul.list")
    expect(page).to have_css("li.list-row", count: 2)
    expect(page).to have_content("Item 1")
    expect(page).to have_content("Item 2")
  end

  it "renders a list with a header" do
    render_inline(described_class.new(header: "My List"))

    expect(page).to have_css(".list")
    expect(page).to have_content("My List")
  end

  it "applies custom CSS classes" do
    render_inline(described_class.new(css: "bg-base-100 rounded-box shadow-md"))

    expect(page).to have_css(".list.bg-base-100.rounded-box.shadow-md")
  end
end
