# frozen_string_literal: true

require "rails_helper"

# Test class that includes the concern directly.
class ActionableTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::ActionableComponent

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

# Test class that also pulls in Turboable, so we can prove the two concerns'
# data attributes coexist on the same element (the nested `data:` form must
# deep-merge, not clobber).
class ActionableTurboTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::ActionableComponent
  include LocoMotion::Concerns::TurboableComponent

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
    add_stimulus_controller(:component, "demo")
  end
end

RSpec.describe LocoMotion::Concerns::ActionableComponent, type: :component do
  context "without an action option" do
    before do
      render_inline(ActionableTestComponent.new)
    end

    it "renders no data-action attribute" do
      expect(page).to have_css("div.test-component")
      expect(page).not_to have_css("[data-action]")
    end
  end

  context "with an action option" do
    before do
      render_inline(ActionableTestComponent.new(action: "click->test#action"))
    end

    it "sets the data-action attribute" do
      expect(page).to have_css("div.test-component[data-action='click->test#action']")
    end

    it "renders exactly one data-action attribute (no duplicate)" do
      # Nested `data: { action: }` must not collide with any flat form and
      # produce `data-action="x" data-action="x"`.
      expect(page.native.to_html.scan("data-action=").length).to eq(1)
    end
  end

  context "with the Stimulus shorthand (no explicit event)" do
    before do
      render_inline(ActionableTestComponent.new(action: "my-controller#handle"))
    end

    it "passes the value through verbatim (Stimulus infers the click event)" do
      expect(page).to have_css("[data-action='my-controller#handle']")
    end
  end

  context "with an explicit html data-action attribute" do
    before do
      render_inline(ActionableTestComponent.new(
                      action: "sugar#method",
                      html: { data: { action: "explicit#method" } }
                    ))
    end

    it "lets the explicit html value take precedence over the option" do
      expect(page).to have_css("[data-action='explicit#method']")
      expect(page).not_to have_css("[data-action='sugar#method']")
    end
  end

  context "with an action alongside a Stimulus controller and turbo option" do
    before do
      render_inline(ActionableTurboTestComponent.new(
                      action: "demo#go",
                      turbo_frame: "modal"
                    ))
    end

    it "keeps data-action, data-controller, and data-turbo-frame all present" do
      expect(page).to have_css("[data-action='demo#go']")
      expect(page).to have_css("[data-controller='demo']")
      expect(page).to have_css("[data-turbo-frame='modal']")
    end
  end
end
