require "rails_helper"

RSpec.describe Daisy::DataDisplay::BadgeComponent, type: :component do
  context "with no options" do
    before do
      render_inline(described_class.new)
    end

    it "renders the component" do
      expect(page).to have_css "span.badge"
    end
  end

  context "with user-defined css" do
    before do
      render_inline(described_class.new(css: "new_css"))
    end

    it "renders the default css" do
      expect(page).to have_css "span.badge"
    end

    it "renders the user-defined css" do
      expect(page).to have_css "span.new_css"
    end
  end

  context "with custom content" do
    before do
      render_inline(described_class.new) do |badge|
        "Hello world!"
      end
    end

    it "renders the custom content" do
      expect(page).to have_text "Hello world!"
    end
  end

  context "with one valid css modifier" do
    before do
      render_inline(described_class.new(css: "badge-primary"))
    end

    it "renders the default css" do
      expect(page).to have_css "span.badge"
    end

    it "renders the modifier css" do
      expect(page).to have_css "span.badge-primary"
    end
  end

  context "with multiple valid css modifiers" do
    before do
      render_inline(described_class.new(css: ["badge-primary", "badge-outline"]))
    end

    it "renders the default css" do
      expect(page).to have_css "span.badge"
    end

    it "renders both modifier's css" do
      expect(page).to have_css "span.badge-primary"
      expect(page).to have_css "span.badge-outline"
    end
  end
end

