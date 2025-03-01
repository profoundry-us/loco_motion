require "rails_helper"

RSpec.describe Daisy::DataDisplay::CardComponent, type: :component do
  context "basic rendering" do
    let(:card) { described_class.new }

    before do
      render_inline(card)
    end

    it "has the card class" do
      expect(page).to have_selector(".card")
    end
  end

  context "with simple title" do
    let(:card) { described_class.new(title: "Card Title") }

    before do
      render_inline(card)
    end

    it "renders the title" do
      expect(page).to have_selector(".card-title", text: "Card Title")
    end
  end

  context "with custom title" do
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_title { "Custom Title" }
      end
    end

    it "renders the custom title" do
      expect(page).to have_selector(".card-title", text: "Custom Title")
    end
  end

  context "with top figure" do
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_top_figure(src: "example.jpg")
      end
    end

    it "renders the figure" do
      expect(page).to have_selector("figure.card-image")
    end

    it "renders the image" do
      expect(page).to have_selector("img[src='example.jpg']")
    end
  end

  context "with bottom figure" do
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_bottom_figure(src: "example.jpg")
      end
    end

    it "renders the figure" do
      expect(page).to have_selector("figure.card-image")
    end

    it "renders the image" do
      expect(page).to have_selector("img[src='example.jpg']")
    end
  end

  context "with actions" do
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_actions { "Action Content" }
      end
    end

    it "renders the actions" do
      expect(page).to have_selector(".card-actions", text: "Action Content")
    end
  end

  context "with custom CSS" do
    let(:card) { described_class.new(css: "custom-class") }

    before do
      render_inline(card)
    end

    it "includes the custom class" do
      expect(page).to have_selector(".card.custom-class")
    end
  end
end
