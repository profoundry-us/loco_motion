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

  context "with an icon" do
    let(:link) { described_class.new(title: "Home", href: "#", icon: "home") }

    before do
      render_inline(link)
    end

    it "renders the icon as an svg" do
      expect(page).to have_css("a svg")
    end

    it "renders the title text" do
      expect(page).to have_text("Home")
    end
  end

  context "with left and right icons" do
    let(:link) { described_class.new(title: "Download", href: "#", left_icon: "arrow-down-tray", right_icon: "arrow-right") }

    before do
      render_inline(link)
    end

    it "renders both icons as svgs" do
      expect(page).to have_css("a svg", count: 2)
    end

    it "renders the title text" do
      expect(page).to have_text("Download")
    end
  end
end
