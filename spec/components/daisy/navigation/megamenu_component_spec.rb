# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::Navigation::MegamenuComponent, type: :component do
  context "basic megamenu" do
    let(:megamenu) { described_class.new(id: "main-menu") }

    before do
      render_inline(megamenu) do |mega|
        mega.with_item(title: "Services", id: "mm-services") do
          "Services content"
        end
        mega.with_item(title: "Cloud", id: "mm-cloud") do
          "Cloud content"
        end
      end
    end

    describe "rendering" do
      it "has the megamenu class on the container" do
        expect(page).to have_selector("div.megamenu", visible: :all)
      end

      it "makes the container a popover with the given id" do
        expect(page).to have_selector("div.megamenu#main-menu[popover]", visible: :all)
      end

      it "renders the active indicator span" do
        expect(page).to have_selector(".megamenu > span.megamenu-active", visible: :all)
      end

      it "renders a button and popover div for each item" do
        expect(page).to have_selector(".megamenu > button[popovertarget]", count: 2, visible: :all)
        expect(page).to have_selector(".megamenu > div[popover]", count: 2, visible: :all)
      end

      it "renders each item's button immediately before its popover" do
        children = page.find(".megamenu", visible: :all).all("> *", visible: :all)
        expect(children.map(&:tag_name)).to eq(%w[button div button div span])
      end

      it "points each button's popovertarget at its popover's id" do
        expect(page).to have_selector("button[popovertarget='mm-services']", text: "Services", visible: :all)
        expect(page).to have_selector(".megamenu > div#mm-services[popover]", text: "Services content",
                                      visible: :all)
        expect(page).to have_selector("button[popovertarget='mm-cloud']", text: "Cloud", visible: :all)
        expect(page).to have_selector(".megamenu > div#mm-cloud[popover]", text: "Cloud content", visible: :all)
      end

      it "renders a toggle button targeting the container" do
        expect(page).to have_selector("button.btn[popovertarget='main-menu']", text: "Menu", visible: :all)
      end
    end
  end

  context "with generated ids" do
    before do
      render_inline(described_class.new) do |mega|
        mega.with_item(title: "Products") { "Products content" }
      end
    end

    it "pairs the button and popover with a matching generated id" do
      button = page.find(".megamenu > button[popovertarget]", visible: :all)
      popover = page.find(".megamenu > div[popover]", visible: :all)

      expect(button[:popovertarget]).to eq(popover[:id])
      expect(button[:popovertarget]).to start_with("megamenu-item-")
    end
  end

  context "with a custom toggle_text" do
    before do
      render_inline(described_class.new(toggle_text: "Browse")) do |mega|
        mega.with_item(title: "Products") { "Content" }
      end
    end

    it "uses the custom text on the toggle button" do
      expect(page).to have_selector("button.btn", text: "Browse", visible: :all)
    end
  end

  context "with a custom toggle slot" do
    before do
      render_inline(described_class.new) do |mega|
        mega.with_toggle { "☰ Open" }
        mega.with_item(title: "Products") { "Content" }
      end
    end

    it "renders the custom content inside the toggle button" do
      expect(page).to have_selector("button.btn", text: "☰ Open", visible: :all)
    end
  end

  context "with toggle disabled" do
    before do
      render_inline(described_class.new(toggle: false)) do |mega|
        mega.with_item(title: "Products") { "Content" }
      end
    end

    it "does not render a toggle button" do
      expect(page).to have_no_selector("button.btn", visible: :all)
    end
  end

  context "with custom CSS" do
    before do
      render_inline(described_class.new(css: "megamenu-wide max-sm:megamenu-vertical")) do |mega|
        mega.with_item(title: "Products") { "Content" }
      end
    end

    it "applies custom CSS classes alongside the megamenu class" do
      expect(page).to have_selector(".megamenu.megamenu-wide.max-sm\\:megamenu-vertical", visible: :all)
    end
  end

  context "with custom HTML attributes" do
    before do
      render_inline(described_class.new(html: { data: { test: "value" } })) do |mega|
        mega.with_item(title: "Products") { "Content" }
      end
    end

    it "passes attributes through to the container" do
      expect(page).to have_selector(".megamenu[data-test='value']", visible: :all)
    end
  end

  context "with the megamenu-wide / megamenu-full modifiers" do
    before do
      render_inline(described_class.new(id: "wide-menu", css: "megamenu-wide")) do |mega|
        mega.with_item(title: "Products") { "Content" }
      end
    end

    # DaisyUI anchors wide/full popovers to a shared `--megamenu` anchor
    # name, which breaks when a page holds more than one megamenu — so the
    # component overrides the pair with a per-instance anchor.
    it "gives the container a unique anchor-name" do
      container = page.find(".megamenu", visible: :all)
      expect(container[:style]).to include("anchor-name:--wide-menu")
    end

    it "points each popover's position-anchor at the container" do
      popover = page.find(".megamenu > div[popover]", visible: :all)
      expect(popover[:style]).to include("position-anchor:--wide-menu")
    end
  end

  context "without the wide / full modifiers" do
    before do
      render_inline(described_class.new(id: "plain-menu")) do |mega|
        mega.with_item(title: "Products") { "Content" }
      end
    end

    it "does not override the anchor pair" do
      container = page.find(".megamenu", visible: :all)
      popover = page.find(".megamenu > div[popover]", visible: :all)

      expect(container[:style].to_s).not_to include("anchor-name")
      expect(popover[:style].to_s).not_to include("position-anchor")
    end
  end
end
