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
end
