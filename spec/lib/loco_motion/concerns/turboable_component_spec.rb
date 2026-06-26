# frozen_string_literal: true

require "rails_helper"

# Test class that includes the concern
class TurboableTestComponent < LocoMotion::BaseComponent
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
  end
end

RSpec.describe LocoMotion::Concerns::TurboableComponent, type: :component do
  context "without any turbo options" do
    before do
      render_inline(TurboableTestComponent.new)
    end

    it "renders no turbo data attributes" do
      expect(page).to have_css("div.test-component")
      expect(page).not_to have_css("[data-turbo-frame]")
      expect(page).not_to have_css("[data-turbo-method]")
      expect(page).not_to have_css("[data-turbo-confirm]")
    end
  end

  context "with turbo_frame" do
    before do
      render_inline(TurboableTestComponent.new(turbo_frame: "modal"))
    end

    it "sets only the data-turbo-frame attribute" do
      expect(page).to have_css("div.test-component[data-turbo-frame='modal']")
      expect(page).not_to have_css("[data-turbo-method]")
      expect(page).not_to have_css("[data-turbo-confirm]")
    end
  end

  context "with turbo_method" do
    before do
      render_inline(TurboableTestComponent.new(turbo_method: :delete))
    end

    it "sets only the data-turbo-method attribute" do
      expect(page).to have_css("div.test-component[data-turbo-method='delete']")
      expect(page).not_to have_css("[data-turbo-frame]")
      expect(page).not_to have_css("[data-turbo-confirm]")
    end
  end

  context "with turbo_confirm" do
    before do
      render_inline(TurboableTestComponent.new(turbo_confirm: "Are you sure?"))
    end

    it "sets only the data-turbo-confirm attribute" do
      expect(page).to have_css("div.test-component[data-turbo-confirm='Are you sure?']")
      expect(page).not_to have_css("[data-turbo-frame]")
      expect(page).not_to have_css("[data-turbo-method]")
    end
  end

  context "with all three turbo options" do
    before do
      render_inline(TurboableTestComponent.new(
                      turbo_frame: "modal",
                      turbo_method: :delete,
                      turbo_confirm: "Are you sure?"
                    ))
    end

    it "sets all three data-turbo attributes" do
      expect(page).to have_css("[data-turbo-frame='modal']")
      expect(page).to have_css("[data-turbo-method='delete']")
      expect(page).to have_css("[data-turbo-confirm='Are you sure?']")
    end
  end

  context "with an explicit html data attribute" do
    before do
      render_inline(TurboableTestComponent.new(
                      turbo_frame: "sugar",
                      html: { data: { turbo_frame: "explicit" } }
                    ))
    end

    it "lets the explicit html value take precedence over the option" do
      expect(page).to have_css("[data-turbo-frame='explicit']")
      expect(page).not_to have_css("[data-turbo-frame='sugar']")
    end
  end

  context "with turbo options and additional HTML attributes" do
    before do
      render_inline(TurboableTestComponent.new(
                      turbo_frame: "modal",
                      html: { id: "custom-component", data: { test: "value" } }
                    ))
    end

    it "preserves other HTML attributes alongside the turbo attribute" do
      expect(page).to have_css("div.test-component#custom-component[data-test='value'][data-turbo-frame='modal']")
    end
  end
end
