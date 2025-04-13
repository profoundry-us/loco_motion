require "rails_helper"

# Test class that includes the concern
class LinkableTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::LinkableComponent
  
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

RSpec.describe LocoMotion::Concerns::LinkableComponent, type: :component do
  context "without href" do
    before do
      render_inline(LinkableTestComponent.new)
    end
    
    it "renders with default tag" do
      expect(page).to have_css("div.test-component")
      expect(page).not_to have_css("a")
    end
  end
  
  context "with href" do
    let(:href) { "/some/path" }
    
    before do
      render_inline(LinkableTestComponent.new(href: href))
    end
    
    it "changes the tag to an anchor" do
      expect(page).to have_css("a.test-component")
      expect(page).not_to have_css("div")
    end
    
    it "sets the href attribute" do
      expect(page).to have_css("a[href=\"#{href}\"]")
    end
  end
  
  context "with href and target" do
    let(:href) { "https://example.com" }
    let(:target) { "_blank" }
    
    before do
      render_inline(LinkableTestComponent.new(href: href, target: target))
    end
    
    it "sets both href and target attributes" do
      expect(page).to have_css("a[href=\"#{href}\"][target=\"#{target}\"]")
    end
  end
  
  context "with additional HTML attributes" do
    let(:href) { "/some/path" }
    
    before do
      render_inline(LinkableTestComponent.new(
        href: href,
        html: { id: "custom-link", data: { test: "value" } }
      ))
    end
    
    it "preserves other HTML attributes" do
      expect(page).to have_css("a.test-component#custom-link[data-test='value']")
    end
  end
  
  context "with custom CSS classes" do
    let(:href) { "/some/path" }
    
    before do
      render_inline(LinkableTestComponent.new(href: href, css: "custom-class"))
    end
    
    it "applies custom CSS classes" do
      expect(page).to have_css("a.test-component.custom-class")
    end
  end
end
