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

  context "with tooltip" do
    let(:tip) { "Card tooltip" }
    let(:card) { described_class.new(tip: tip) }

    before do
      render_inline(card)
    end

    describe "rendering" do
      it "includes tooltip class" do
        expect(page).to have_selector(".card.tooltip")
      end

      it "sets data-tip attribute" do
        expect(page).to have_css("[data-tip=\"#{tip}\"]")
      end
    end
  end

  context "with figure content instead of image" do
    let(:figure_content) { "Custom figure content" }
    let(:card) { described_class.new }

    before do
      render_inline(card) do |c|
        c.with_top_figure { figure_content }
      end
    end

    describe "rendering" do
      it "renders the figure content" do
        expect(page).to have_selector(".card figure", text: figure_content)
      end

      it "does not render an image" do
        expect(page).not_to have_selector(".card figure img")
      end
    end
  end

  context "with title precedence" do
    let(:simple_title) { "Simple Title" }
    let(:custom_title) { "Custom Title" }
    let(:card) { described_class.new(title: simple_title) }

    before do
      render_inline(card) do |c|
        c.with_title { custom_title }
      end
    end

    describe "rendering" do
      it "uses the custom title" do
        expect(page).to have_selector(".card-title", text: custom_title)
      end

      it "does not render the simple title" do
        expect(page).not_to have_content(simple_title)
      end
    end
  end

  context "with complex configuration" do
    let(:title) { "Complex Card" }
    let(:content) { "Card content" }
    let(:action_text) { "Action Button" }
    let(:top_image) { "/images/top.jpg" }
    let(:bottom_image) { "/images/bottom.jpg" }
    let(:tip) { "Complex card tooltip" }
    let(:card) { described_class.new(title: title, tip: tip, css: "bg-base-100 shadow-xl") }

    before do
      render_inline(card) do |c|
        c.with_top_figure(src: top_image)
        c.with_title { title }
        c.with_actions { content_tag(:button, action_text) }
        c.with_bottom_figure(src: bottom_image)
        content
      end
    end

    describe "rendering" do
      it "renders all components in correct order" do
        elements = page.all(".card > *")
        expect(elements[0].tag_name).to eq("figure")
        expect(elements[1][:class]).to include("card-body")
        expect(elements[2].tag_name).to eq("figure")
      end

      it "renders the title" do
        expect(page).to have_selector(".card-title", text: title)
      end

      it "renders the content" do
        expect(page).to have_content(content)
      end

      it "renders the actions" do
        expect(page).to have_selector(".card-actions button", text: action_text)
      end

      it "renders both figures" do
        expect(page).to have_selector("figure img[src='#{top_image}']")
        expect(page).to have_selector("figure img[src='#{bottom_image}']")
      end

      it "includes tooltip" do
        expect(page).to have_selector(".card.tooltip")
        expect(page).to have_css("[data-tip=\"#{tip}\"]")
      end

      it "includes custom classes" do
        expect(page).to have_selector(".card.bg-base-100.shadow-xl")
      end
    end
  end
end
