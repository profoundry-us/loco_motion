# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocoMotion::ComponentConfig, type: :component do
  # A component with an extra part so we can exercise per-part shortcuts.
  class AriaConfigComponent < LocoMotion::BaseComponent
    define_part :inner

    def call
      part(:component) do
        part(:inner) { "Inner" }
      end
    end
  end

  # A component that sets default aria/data via the author helpers.
  class AuthorAriaComponent < LocoMotion::BaseComponent
    def call
      part(:component) { "Content" }
    end

    def before_render
      super

      add_aria(:component, label: "Author Label")
      add_data(:component, role: "widget")
    end
  end

  describe "user-facing aria: shortcut" do
    it "renders top-level aria as aria-* on the component part" do
      render_inline(AriaConfigComponent.new(aria: { label: "Save", pressed: true }))

      expect(page).to have_css("div[aria-label='Save'][aria-pressed='true']")
    end

    it "renders per-part {part}_aria on the matching part" do
      render_inline(AriaConfigComponent.new(inner_aria: { hidden: true }))

      expect(page).to have_css("div[aria-hidden='true']", text: "Inner")
    end
  end

  describe "user-facing data: shortcut" do
    it "renders top-level data as data-* on the component part" do
      render_inline(AriaConfigComponent.new(data: { foo: "bar" }))

      expect(page).to have_css("div[data-foo='bar']")
    end

    it "renders per-part {part}_data on the matching part" do
      render_inline(AriaConfigComponent.new(inner_data: { baz: "qux" }))

      expect(page).to have_css("div[data-baz='qux']", text: "Inner")
    end
  end

  describe "author helpers" do
    it "renders defaults added via add_aria and add_data" do
      render_inline(AuthorAriaComponent.new)

      expect(page).to have_css("div[aria-label='Author Label'][data-role='widget']")
    end

    it "lets the user override an author default via the aria: shortcut" do
      render_inline(AuthorAriaComponent.new(aria: { label: "User Label" }))

      expect(page).to have_css("div[aria-label='User Label']")
    end
  end
end
