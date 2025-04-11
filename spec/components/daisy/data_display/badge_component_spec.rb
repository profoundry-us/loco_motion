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
      render_inline(described_class.new) { "Hello world!" }
    end

    it "renders the custom content" do
      expect(page).to have_text "Hello world!"
    end
  end

  context "with title as positional argument" do
    before do
      render_inline(described_class.new("Badge Title"))
    end

    it "renders the title" do
      expect(page).to have_text "Badge Title"
    end
  end

  context "with title as keyword argument" do
    let(:title) { "Badge Title" }
    before do
      render_inline(described_class.new(title: title))
    end

    it "renders the title" do
      expect(page).to have_text title
    end
  end

  context "with title and block" do
    let(:title) { "Title Argument" }
    let(:content) { "Block Content" }

    before do
      render_inline(described_class.new(title: title)) { content }
    end

    it "prioritizes block content over title" do
      expect(page).to have_text content
      expect(page).not_to have_text title
    end
  end

  context "with modifiers" do
    modifiers = %w[primary secondary accent ghost success error warning]

    modifiers.each do |modifier|
      context "with #{modifier} modifier" do
        before do
          render_inline(described_class.new(css: "badge-#{modifier}"))
        end

        it "renders with #{modifier} class" do
          expect(page).to have_css "span.badge.badge-#{modifier}"
        end
      end
    end
  end

  context "with sizes" do
    sizes = {
      "lg" => "large",
      "md" => "medium",
      "sm" => "small",
      "xs" => "extra small"
    }

    sizes.each do |size_class, size_name|
      context "with #{size_name} size" do
        before do
          render_inline(described_class.new(css: "badge-#{size_class}"))
        end

        it "renders with #{size_class} class" do
          expect(page).to have_css "span.badge.badge-#{size_class}"
        end
      end
    end
  end

  context "with tooltip" do
    let(:tip) { "Badge tooltip" }
    before do
      render_inline(described_class.new(tip: tip))
    end

    it "includes tooltip class" do
      expect(page).to have_css "span.badge.tooltip"
    end

    it "sets data-tip attribute" do
      expect(page).to have_css "[data-tip=\"#{tip}\"]" 
    end
  end

  context "with complex configuration" do
    let(:title) { "Complex Badge" }
    let(:tip) { "Complex tooltip" }

    before do
      render_inline(described_class.new(
        title: title,
        tip: tip,
        css: "badge-primary badge-lg"
      ))
    end

    it "renders with all configurations" do
      expect(page).to have_text title
      expect(page).to have_css "span.badge.badge-primary.badge-lg.tooltip"
      expect(page).to have_css "[data-tip=\"#{tip}\"]"
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
  
  # Tests for the new link functionality
  context "with href" do
    let(:href) { "/some/path" }
    before do
      render_inline(described_class.new(title: "Linked Badge", href: href))
    end

    it "renders as an anchor tag" do
      expect(page).to have_css "a.badge"
    end

    it "has the correct href" do
      expect(page).to have_css "a[href=\"#{href}\"]"
    end
  end

  context "with href and target" do
    let(:href) { "https://example.com" }
    let(:target) { "_blank" }
    
    before do
      render_inline(described_class.new(
        title: "External Link", 
        href: href, 
        target: target
      ))
    end

    it "has the target attribute" do
      expect(page).to have_css "a[target=\"#{target}\"]"
    end
  end
  
  # Tests for the new icon functionality
  context "with left icon" do
    before do
      render_inline(described_class.new(title: "Icon Badge", left_icon: "star"))
    end

    it "renders with the flex and gap classes" do
      expect(page).to have_css "span.badge.where\\:inline-flex.where\\:items-center.where\\:gap-2"
    end
    
    it "includes the icon in the rendered output" do
      # Verify that the SVG (heroicon) is present in the output
      expect(page).to have_css "span.badge svg"
    end
  end
  
  context "with right icon" do
    before do
      render_inline(described_class.new(title: "Badge with Right Icon", right_icon: "arrow-right"))
    end

    it "renders with the flex and gap classes" do
      expect(page).to have_css "span.badge.where\\:inline-flex.where\\:items-center.where\\:gap-2"
    end
    
    it "includes the icon in the rendered output" do
      expect(page).to have_css "span.badge svg"
    end
  end
  
  context "with both left and right icons" do
    before do
      render_inline(described_class.new(
        title: "Dual Icons", 
        left_icon: "star", 
        right_icon: "arrow-right"
      ))
    end

    it "renders with the flex and gap classes" do
      expect(page).to have_css "span.badge.where\\:inline-flex.where\\:items-center.where\\:gap-2"
    end
    
    it "includes two icons in the rendered output" do
      # Count the number of SVGs to ensure there are two
      expect(page).to have_css "span.badge svg", count: 2
    end
  end
  
  context "with icon alias" do
    before do
      render_inline(described_class.new(title: "Icon Alias", icon: "star"))
    end

    it "renders the icon using the icon alias" do
      expect(page).to have_css "span.badge svg"
    end
  end
  
  context "with icon and href" do
    before do
      render_inline(described_class.new(
        title: "Linked with Icon", 
        left_icon: "link", 
        href: "/docs"
      ))
    end

    it "renders as an anchor with the icon" do
      expect(page).to have_css "a.badge"
      expect(page).to have_css "a.badge svg"
    end
  end
end
