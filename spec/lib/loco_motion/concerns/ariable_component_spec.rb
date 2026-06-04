# frozen_string_literal: true

require "rails_helper"

# Test class that includes the concern and exposes a `required` option, just
# like the real input components do.
class AriableTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::AriableComponent

  def initialize(**kws)
    super
    @required = config_option(:required, false)
  end

  def call
    part(:component) { "Test Content" }
  end

  def before_render
    super

    set_tag_name(:component, :input)
  end
end

RSpec.describe LocoMotion::Concerns::AriableComponent, type: :component do
  context "when required is true" do
    it "adds aria-required" do
      render_inline(AriableTestComponent.new(required: true))

      expect(page).to have_css("input[aria-required='true']")
    end
  end

  context "when required is false or omitted" do
    it "does not add aria-required" do
      render_inline(AriableTestComponent.new)

      expect(page).not_to have_css("input[aria-required]")
    end
  end

  context "when the user provides aria-required explicitly" do
    it "does not override the nested aria form" do
      render_inline(AriableTestComponent.new(required: true, aria: { required: false }))

      expect(page).to have_css("input[aria-required='false']")
    end

    it "does not override the dasherized html form" do
      render_inline(AriableTestComponent.new(required: true, html: { "aria-required": "false" }))

      expect(page).to have_css("input[aria-required='false']")
      expect(page).not_to have_css("input[aria-required='true']")
    end
  end
end
