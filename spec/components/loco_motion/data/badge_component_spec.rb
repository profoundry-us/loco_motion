require "rails_helper"

RSpec.describe LocoMotion::Data::BadgeComponent, type: :component do
  context "testing failure" do
    it "dies" do
      raise "Oops..."
    end
  end

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

  context "with one valid variant" do
    before do
      render_inline(described_class.new(variant: :primary))
    end

    it "renders the default css" do
      expect(page).to have_css "span.badge"
    end

    it "renders the variant css" do
      expect(page).to have_css "span.badge-primary"
    end
  end

  context "with multiple valid variants" do
    before do
      render_inline(described_class.new(variants: [:primary, :outline]))
    end

    it "renders the default css" do
      expect(page).to have_css "span.badge"
    end

    it "renders both variant's css" do
      expect(page).to have_css "span.badge-primary"
      expect(page).to have_css "span.badge-outline"
    end
  end

  context "with an invalid variant" do
    it "raises an error" do
      expect {
        render_inline(described_class.new(variant: :doesnotexist))
      }.to raise_error(LocoMotion::InvalidVariantError)
    end
  end
end

