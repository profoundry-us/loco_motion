# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::Navigation::LinkComponent, type: :component do
  context "with a positional link argument and no content" do
    let(:link) { described_class.new("https://example.com") }

    before do
      render_inline(link)
    end

    it "renders the link as text" do
      expect(page).to have_text("https://example.com")
    end
  end

  context "with a positional link argument and content" do
    let(:link) { described_class.new("https://example.com") }

    before do
      render_inline(link) { "Click me!" }
    end

    it "renders the block content" do
      expect(page).to have_text("Click me!")
    end
  end

  context "with two positional arguments" do
    let(:link) { described_class.new("Some Text", "https://example.com") }

    before do
      render_inline(link)
    end

    it "renders the first postional argument as text" do
      expect(page).to have_text("Some Text")
    end

    it "renders the second positional argument as the href" do
      expect(page).to have_css("a[href='https://example.com']")
    end
  end

  context "with two keyword arguments" do
    let(:link) { described_class.new(title: "Some Text", href: "https://example.com") }

    before do
      render_inline(link)
    end

    it "renders the first postional argument as text" do
      expect(page).to have_text("Some Text")
    end

    it "renders the second positional argument as the href" do
      expect(page).to have_css("a[href='https://example.com']")
    end
  end

  context "with a Stimulus action" do
    context "given the action option" do
      before do
        render_inline(described_class.new(title: "Toggle", href: "#", action: "click->loco-theme#setTheme"))
      end

      it "adds the data-action attribute (gained via ActionableComponent)" do
        expect(page).to have_css("a.link[data-action='click->loco-theme#setTheme']")
      end
    end

    context "given an action alongside a turbo option" do
      before do
        render_inline(described_class.new(title: "Toggle", href: "#", action: "x#y", turbo_frame: "modal"))
      end

      it "keeps both data-action and data-turbo-frame (neither clobbers the other)" do
        expect(page).to have_css("a.link[data-action='x#y'][data-turbo-frame='modal']")
      end
    end

    context "given an explicit html data-action" do
      before do
        render_inline(described_class.new(title: "Toggle", href: "#", action: "sugar#a",
                                          html: { data: { action: "explicit#b" } }))
      end

      it "lets the explicit html value win over the action option" do
        expect(page).to have_css("a.link[data-action='explicit#b']")
        expect(page).not_to have_css("[data-action='sugar#a']")
      end
    end

    context "without an action option" do
      before do
        render_inline(described_class.new(title: "Plain", href: "#"))
      end

      it "renders no data-action attribute" do
        expect(page).not_to have_css("[data-action]")
      end
    end
  end

  context "with icons" do
    context "with a single icon" do
      let(:link) { described_class.new(title: "Home", href: "#", icon: "home") }

      before do
        render_inline(link)
      end

      it "renders the icon" do
        expect(page).to have_css "a svg"
      end

      it "renders the title" do
        expect(page).to have_text("Home")
      end

      it "adds inline-flex and items-center classes" do
        expect(page).to have_css "a[class*='inline-flex'][class*='items-center']"
      end
    end

    context "with left and right icons" do
      let(:link) do
        described_class.new(title: "Navigate", href: "#", left_icon: "arrow-left", right_icon: "arrow-right")
      end

      before do
        render_inline(link)
      end

      it "renders both icons" do
        expect(page).to have_css "a svg", count: 2
      end

      it "renders the title between the icons" do
        expect(page).to have_text("Navigate")
      end
    end
  end
end
