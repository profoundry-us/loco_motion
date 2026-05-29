require "rails_helper"

RSpec.describe Daisy::DataDisplay::TextRotateComponent, type: :component do
  context "basic text rotate" do
    let(:text_rotate) { described_class.new }

    before do
      render_inline(text_rotate) do |rotate|
        rotate.with_item { "ONE" }
        rotate.with_item { "TWO" }
        rotate.with_item { "THREE" }
      end
    end

    describe "rendering" do
      it "has the text-rotate class" do
        expect(page).to have_selector(".text-rotate")
      end

      it "renders as a span element" do
        expect(page).to have_selector("span.text-rotate")
      end

      it "renders all items" do
        expect(page).to have_content("ONE")
        expect(page).to have_content("TWO")
        expect(page).to have_content("THREE")
      end
    end
  end

  context "with texts shorthand" do
    let(:texts) { %w[DESIGN DEVELOP DEPLOY] }
    let(:text_rotate) { described_class.new(texts: texts) }

    before do
      render_inline(text_rotate)
    end

    describe "rendering" do
      it "has the text-rotate class" do
        expect(page).to have_selector(".text-rotate")
      end

      it "renders all texts" do
        texts.each do |text|
          expect(page).to have_content(text)
        end
      end
    end
  end

  context "with custom CSS" do
    let(:custom_class) { "text-7xl duration-6000" }
    let(:text_rotate) { described_class.new(css: custom_class) }

    before do
      render_inline(text_rotate) do |rotate|
        rotate.with_item { "BLAZING" }
        rotate.with_item { "FAST" }
      end
    end

    describe "rendering" do
      it "includes custom classes" do
        custom_class.split.each do |css_class|
          expect(page).to have_selector(".text-rotate.#{css_class}")
        end
      end

      it "maintains default classes" do
        expect(page).to have_selector(".text-rotate")
      end
    end
  end

  context "with wrapper CSS" do
    let(:wrapper_css) { "justify-items-center" }
    let(:text_rotate) { described_class.new(wrapper_css: wrapper_css) }

    before do
      render_inline(text_rotate) do |rotate|
        rotate.with_item { "DESIGN" }
        rotate.with_item { "DEVELOP" }
      end
    end

    describe "rendering" do
      it "includes wrapper CSS classes on the wrapper part" do
        wrapper_css.split.each do |css_class|
          expect(page).to have_selector(".text-rotate span.#{css_class}")
        end
      end
    end
  end

  context "with item links" do
    let(:text_rotate) { described_class.new }

    before do
      render_inline(text_rotate) do |rotate|
        rotate.with_item(href: "https://example.com") { "DEVELOP" }
        rotate.with_item { "DESIGN" }
      end
    end

    describe "rendering" do
      it "renders an item with an href as an anchor tag" do
        expect(page).to have_selector("a.text-rotate-item[href='https://example.com']", text: "DEVELOP")
      end

      it "renders items without an href as span tags" do
        expect(page).to have_selector("span.text-rotate-item", text: "DESIGN")
      end
    end
  end

  context "with item icons" do
    let(:text_rotate) { described_class.new }

    before do
      render_inline(text_rotate) do |rotate|
        rotate.with_item(left_icon: "sparkles") { "DESIGN" }
        rotate.with_item(right_icon: "rocket-launch") { "DEPLOY" }
      end
    end

    describe "rendering" do
      it "renders the icons" do
        expect(page).to have_selector(".text-rotate-item svg", count: 2)
      end

      it "renders the item content alongside the icons" do
        expect(page).to have_content("DESIGN")
        expect(page).to have_content("DEPLOY")
      end
    end
  end

  context "with custom content instead of items" do
    let(:text_rotate) { described_class.new }

    before do
      render_inline(text_rotate) do
        "<span class=\"text-rotate-item custom-item\">CUSTOM</span>".html_safe
      end
    end

    describe "rendering" do
      it "renders the custom content inside the wrapper" do
        expect(page).to have_selector(".text-rotate span .custom-item", text: "CUSTOM")
      end
    end
  end

  context "with item CSS" do
    let(:text_rotate) { described_class.new }

    before do
      render_inline(text_rotate) do |rotate|
        rotate.with_item(css: "bg-teal-400 text-teal-800 px-2") { "Designers" }
        rotate.with_item(css: "bg-red-400 text-red-800 px-2") { "Developers" }
      end
    end

    describe "rendering" do
      it "includes item CSS classes" do
        expect(page).to have_selector(".text-rotate-item.bg-teal-400")
        expect(page).to have_selector(".text-rotate-item.bg-red-400")
      end

      it "renders item content" do
        expect(page).to have_content("Designers")
        expect(page).to have_content("Developers")
      end
    end
  end

  context "with tooltip" do
    let(:tip) { "Rotating text" }
    let(:text_rotate) { described_class.new(tip: tip) }

    before do
      render_inline(text_rotate) do |rotate|
        rotate.with_item { "ONE" }
        rotate.with_item { "TWO" }
      end
    end

    describe "rendering" do
      it "includes tooltip class" do
        expect(page).to have_selector(".text-rotate.tooltip")
      end

      it "sets data-tip attribute" do
        expect(page).to have_css("[data-tip=\"#{tip}\"]")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".text-rotate")
      end
    end
  end

  context "with maximum 6 items" do
    let(:texts) { %w[ONE TWO THREE FOUR FIVE SIX] }
    let(:text_rotate) { described_class.new(texts: texts) }

    before do
      render_inline(text_rotate)
    end

    describe "rendering" do
      it "renders all 6 items" do
        texts.each do |text|
          expect(page).to have_content(text)
        end
      end
    end
  end
end
