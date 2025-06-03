require "rails_helper"

# Test class that includes the concern
class IconableTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::IconableComponent

  def call
    content = ""
    content += helpers.heroicon(@left_icon, **left_icon_html) if @left_icon
    content += "Test Content"
    content += helpers.heroicon(@right_icon, **right_icon_html) if @right_icon
    part(:component) { content.html_safe }
  end

  def before_render
    setup_component
    super
  end

  def setup_component
    set_tag_name(:component, :div)
    add_css(:component, "test-component")
  end
end

RSpec.describe LocoMotion::Concerns::IconableComponent, type: :component do
  context "with no icons" do
    before do
      render_inline(IconableTestComponent.new)
    end

    it "renders without icon classes" do
      expect(page).to have_css("div.test-component")
      expect(page).not_to have_css(".where\\:inline-flex")
      expect(page).not_to have_css("svg")
    end

    it "reports no icons present" do
      component = IconableTestComponent.new
      expect(component.has_icons?).to be_falsey
    end
  end

  context "with left icon" do
    before do
      render_inline(IconableTestComponent.new(left_icon: "star"))
    end

    it "adds flex classes for proper icon alignment" do
      expect(page).to have_css(".where\\:inline-flex.where\\:items-center.where\\:gap-2")
    end

    it "renders the icon" do
      expect(page).to have_css("svg")
    end

    it "reports icons present" do
      component = IconableTestComponent.new(left_icon: "star")
      expect(component.has_icons?).to be_truthy
    end
  end

  context "with right icon" do
    before do
      render_inline(IconableTestComponent.new(right_icon: "arrow-right"))
    end

    it "adds flex classes for proper icon alignment" do
      expect(page).to have_css(".where\\:inline-flex.where\\:items-center.where\\:gap-2")
    end

    it "renders the icon" do
      expect(page).to have_css("svg")
    end
  end

  context "with both left and right icons" do
    before do
      render_inline(IconableTestComponent.new(
        left_icon: "star",
        right_icon: "arrow-right"
      ))
    end

    it "renders both icons" do
      expect(page).to have_css("svg", count: 2)
    end
  end

  context "with icon alias" do
    before do
      render_inline(IconableTestComponent.new(icon: "star"))
    end

    it "uses the icon as left_icon" do
      expect(page).to have_css("svg")
    end
  end

  context "with custom icon classes" do
    before do
      render_inline(IconableTestComponent.new(
        left_icon: "star",
        left_icon_css: "text-blue-500 size-6"
      ))
    end

    it "applies custom CSS classes to the icon" do
      expect(page).to have_css("svg.text-blue-500.size-6")
    end
  end

  context "with custom icon HTML attributes" do
    let(:component) { IconableTestComponent.new(left_icon: "star", left_icon_html: { data: { test: "value" } }) }

    it "properly builds the HTML attributes hash" do
      # Test the actual helper method that builds the attributes hash
      attrs = component.left_icon_html
      expect(attrs).to include(data: { test: "value" })
    end

    # We don't need to test the actual rendering since that depends on the heroicon helper
    # which is tested separately
  end
end
