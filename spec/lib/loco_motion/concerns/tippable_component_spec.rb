require "rails_helper"

# Test class that includes the concern
class TippableTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent
  
  def call
    part(:component) { "Test Content" }
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

RSpec.describe LocoMotion::Concerns::TippableComponent, type: :component do
  context "without tooltip" do
    before do
      render_inline(TippableTestComponent.new)
    end
    
    it "renders without tooltip classes" do
      expect(page).to have_css("div.test-component")
      expect(page).not_to have_css(".tooltip")
      expect(page).not_to have_css("[data-tip]")
    end
  end
  
  context "with tooltip" do
    let(:tip_text) { "This is a tooltip" }
    
    before do
      render_inline(TippableTestComponent.new(tip: tip_text))
    end
    
    it "adds tooltip class" do
      expect(page).to have_css("div.test-component.tooltip")
    end
    
    it "sets data-tip attribute with tooltip text" do
      expect(page).to have_css("[data-tip=\"#{tip_text}\"]")
    end
  end
  
  context "with tooltip and additional HTML attributes" do
    let(:tip_text) { "Tooltip with attributes" }
    
    before do
      render_inline(TippableTestComponent.new(
        tip: tip_text,
        html: { id: "custom-component", data: { test: "value" } }
      ))
    end
    
    it "preserves other HTML attributes" do
      expect(page).to have_css("div.test-component.tooltip#custom-component[data-test='value']")
    end
    
    it "still includes tooltip data attribute" do
      expect(page).to have_css("[data-tip=\"#{tip_text}\"]")
    end
  end
  
  context "with tooltip and custom CSS classes" do
    let(:tip_text) { "Styled tooltip" }
    
    before do
      render_inline(TippableTestComponent.new(tip: tip_text, css: "custom-class"))
    end
    
    it "applies custom CSS classes alongside tooltip class" do
      expect(page).to have_css("div.test-component.tooltip.custom-class")
    end
  end
  
  context "with empty tooltip text" do
    before do
      render_inline(TippableTestComponent.new(tip: ""))
    end
    
    it "still adds tooltip class" do
      expect(page).to have_css("div.test-component.tooltip")
    end
    
    it "sets data-tip attribute with empty value" do
      expect(page).to have_css("[data-tip=\"\"]")
    end
  end
end
