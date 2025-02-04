require "rails_helper"

RSpec.describe Daisy::DataDisplay::CardComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "with simple title" do
    let(:title) { "Simple Card Title" }
    let(:card) { described_class.new(title: title) }

    before do
      render_inline(card)
    end

    describe "rendering" do
      it "renders the title" do
        expect(page).to have_content title
      end

      it "renders the title in the correct container" do
        expect(page).to have_selector(".card .card-body .card-title", text: title)
      end
    end
  end

  context "with custom title" do
    let(:title_text) { "Custom Card Title" }
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_title { title_text }
      end
    end

    describe "rendering" do
      it "renders the title" do
        expect(page).to have_content title_text
      end

      it "renders the title in the correct container" do
        expect(page).to have_selector(".card .card-body .card-title", text: title_text)
      end
    end
  end

  context "with content" do
    let(:content) { "Card content" }
    let(:card) { described_class.new }

    before do
      render_inline(card) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content content
      end

      it "renders the content in the correct container" do
        expect(page).to have_selector(".card .card-body", text: content)
      end
    end
  end

  context "with top figure" do
    let(:src) { "/images/test.jpg" }
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_top_figure(src: src)
      end
    end

    describe "rendering" do
      it "renders the figure" do
        expect(page).to have_selector(".card figure")
      end

      it "renders the image with correct src" do
        expect(page).to have_selector(".card figure img[src='#{src}']")
      end

      it "renders the figure before the body" do
        elements = page.all(".card > *")
        expect(elements[0].tag_name).to eq("figure")
        expect(elements[1][:class]).to include("card-body")
      end
    end
  end

  context "with bottom figure" do
    let(:src) { "/images/test.jpg" }
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_bottom_figure(src: src)
      end
    end

    describe "rendering" do
      it "renders the figure" do
        expect(page).to have_selector(".card figure")
      end

      it "renders the image with correct src" do
        expect(page).to have_selector(".card figure img[src='#{src}']")
      end

      it "renders the figure after the body" do
        elements = page.all(".card > *")
        expect(elements[0][:class]).to include("card-body")
        expect(elements[1].tag_name).to eq("figure")
      end
    end
  end

  context "with actions" do
    let(:action_text) { "Action Button" }
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_actions { content_tag(:button, action_text) }
      end
    end

    describe "rendering" do
      it "renders the actions" do
        expect(page).to have_content action_text
      end

      it "renders the actions in the correct container" do
        expect(page).to have_selector(".card .card-body .card-actions button", text: action_text)
      end
    end
  end

  context "with custom CSS classes" do
    let(:custom_class) { "custom-card" }
    let(:card) { described_class.new(css: custom_class) }

    before do
      render_inline(card)
    end

    describe "rendering" do
      it "includes the custom class" do
        expect(page).to have_selector(".card.#{custom_class}")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".card")
      end
    end
  end
end
