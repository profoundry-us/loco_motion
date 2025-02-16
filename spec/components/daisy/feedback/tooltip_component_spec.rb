require "rails_helper"

RSpec.describe Daisy::Feedback::TooltipComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "with tip as first argument" do
    let(:tip) { "Tooltip text" }
    let(:content) { "Hover me" }
    let(:tooltip) { described_class.new(tip) }

    before do
      render_inline(tooltip) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content(content)
      end

      it "has the tooltip class" do
        expect(page).to have_selector(".tooltip")
      end

      it "sets the data-tip attribute" do
        expect(page).to have_selector("[data-tip='#{tip}']")
      end
    end
  end

  context "with tip as keyword argument" do
    let(:tip) { "Tooltip text" }
    let(:content) { "Hover me" }
    let(:tooltip) { described_class.new(tip: tip) }

    before do
      render_inline(tooltip) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content(content)
      end

      it "has the tooltip class" do
        expect(page).to have_selector(".tooltip")
      end

      it "sets the data-tip attribute" do
        expect(page).to have_selector("[data-tip='#{tip}']")
      end
    end
  end

  context "with custom CSS classes" do
    let(:custom_class) { "tooltip-bottom tooltip-info" }
    let(:tooltip) { described_class.new("Tooltip text", css: custom_class) }

    before do
      render_inline(tooltip) { "Hover me" }
    end

    describe "rendering" do
      it "includes custom classes" do
        expect(page).to have_selector(".tooltip.#{custom_class.gsub(" ", ".")}")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".tooltip")
      end
    end
  end

  context "with HTML content" do
    let(:tooltip) { described_class.new("Tooltip text") }
    let(:custom_content) do
      content_tag(:div, class: "wrapper") do
        content_tag(:span, "Hover", class: "text") +
        content_tag(:strong, "Me")
      end
    end

    before do
      render_inline(tooltip) { custom_content }
    end

    describe "rendering" do
      it "renders custom HTML structure" do
        expect(page).to have_selector(".tooltip .wrapper")
        expect(page).to have_selector(".tooltip .wrapper .text")
        expect(page).to have_selector(".tooltip .wrapper strong")
      end

      it "preserves text content" do
        expect(page).to have_content("Hover")
        expect(page).to have_content("Me")
      end
    end
  end

  context "without tip" do
    let(:content) { "No tooltip" }
    let(:tooltip) { described_class.new }

    before do
      render_inline(tooltip) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content(content)
      end

      it "has the tooltip class" do
        expect(page).to have_selector(".tooltip")
      end

      it "does not set the data-tip attribute" do
        expect(page).not_to have_selector("[data-tip]")
      end
    end
  end

  context "with complex content" do
    let(:tooltip) { described_class.new("Tooltip for button") }
    let(:button) { content_tag(:button, "Click me", class: "btn") }

    before do
      render_inline(tooltip) { button }
    end

    describe "rendering" do
      it "renders the button" do
        expect(page).to have_selector(".tooltip button.btn")
      end

      it "preserves button text" do
        expect(page).to have_content("Click me")
      end

      it "sets the tooltip text" do
        expect(page).to have_selector("[data-tip='Tooltip for button']")
      end
    end
  end
end
