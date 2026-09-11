# frozen_string_literal: true

require "rails_helper"

# Test class that includes the concern
class StickableTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::StickableComponent

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

RSpec.describe LocoMotion::Concerns::StickableComponent, type: :component do
  context "without the sticky option" do
    before do
      render_inline(StickableTestComponent.new)
    end

    it "renders no sticky class, controller, or edge value" do
      expect(page).to have_css("div.test-component")
      expect(page).not_to have_css(".sticky")
      expect(page).not_to have_css("[data-controller]")
      expect(page).not_to have_css("[data-loco-sticky-edge-value]")
    end
  end

  context "with sticky: false" do
    it "renders nothing sticky" do
      render_inline(StickableTestComponent.new(sticky: false))

      expect(page).not_to have_css(".sticky")
    end
  end

  context "with sticky: \"top\"" do
    before do
      render_inline(StickableTestComponent.new(sticky: "top"))
    end

    it "adds the sticky class and the loco-sticky controller" do
      expect(page).to have_css("div.test-component.sticky[data-controller='loco-sticky']")
    end

    it "omits the edge value, which is the controller's default" do
      expect(page).not_to have_css("[data-loco-sticky-edge-value]")
    end
  end

  context "with sticky: true" do
    it "means the top edge" do
      render_inline(StickableTestComponent.new(sticky: true))

      expect(page).to have_css(".sticky[data-controller='loco-sticky']")
      expect(page).not_to have_css("[data-loco-sticky-edge-value]")
    end
  end

  context "with another single edge" do
    it "passes the edge to the controller" do
      render_inline(StickableTestComponent.new(sticky: :left))

      expect(page).to have_css(".sticky[data-controller='loco-sticky'][data-loco-sticky-edge-value='left']")
    end
  end

  context "with several edges" do
    it "accepts an array" do
      render_inline(StickableTestComponent.new(sticky: %w[top left]))

      expect(page).to have_css("[data-loco-sticky-edge-value='top left']")
    end

    it "accepts a space-separated string" do
      render_inline(StickableTestComponent.new(sticky: "bottom right"))

      expect(page).to have_css("[data-loco-sticky-edge-value='bottom right']")
    end

    it "de-duplicates and downcases" do
      render_inline(StickableTestComponent.new(sticky: ["Top", :top, "LEFT"]))

      expect(page).to have_css("[data-loco-sticky-edge-value='top left']")
    end
  end

  context "with an unknown edge" do
    it "raises an ArgumentError naming the bad edge" do
      expect { StickableTestComponent.new(sticky: "middle") }
        .to raise_error(ArgumentError, /Invalid sticky edge middle; expected one or more of top, bottom, left, right/)
    end
  end

  context "alongside another Stimulus controller" do
    it "appends loco-sticky rather than replacing the existing controller" do
      component = StickableTestComponent.new(sticky: "top")
      component.add_stimulus_controller(:component, "my-nav")
      render_inline(component)

      expect(page).to have_css("[data-controller='my-nav loco-sticky']")
    end
  end

  context "with an explicit data-controller in html" do
    it "keeps the user's attribute (user html wins over defaults)" do
      render_inline(StickableTestComponent.new(sticky: "top", html: { data: { controller: "custom" } }))

      expect(page).to have_css("[data-controller='custom']")
    end
  end

  describe "#sticky? and #sticky_edges" do
    it "expose the parsed edges" do
      component = StickableTestComponent.new(sticky: %w[top left])

      expect(component.sticky?).to be(true)
      expect(component.sticky_edges).to eq(%w[top left])
    end

    it "report not sticky when the option is absent" do
      component = StickableTestComponent.new

      expect(component.sticky?).to be(false)
      expect(component.sticky_edges).to eq([])
    end
  end
end
