require "rails_helper"

RSpec.describe Daisy::Feedback::SkeletonComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "basic skeleton" do
    let(:skeleton) { described_class.new }

    before do
      render_inline(skeleton)
    end

    describe "rendering" do
      it "has the skeleton class" do
        expect(page).to have_selector(".skeleton")
      end
    end
  end

  context "with dimensions" do
    let(:dimensions) { "size-24" }
    let(:skeleton) { described_class.new(css: dimensions) }

    before do
      render_inline(skeleton)
    end

    describe "rendering" do
      it "includes dimension classes" do
        expect(page).to have_selector(".skeleton.size-24")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".skeleton")
      end
    end
  end

  context "with shape" do
    let(:shape) { "rounded-full" }
    let(:skeleton) { described_class.new(css: shape) }

    before do
      render_inline(skeleton)
    end

    describe "rendering" do
      it "includes shape class" do
        expect(page).to have_selector(".skeleton.rounded-full")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".skeleton")
      end
    end
  end

  context "with content" do
    let(:content) { "Loading..." }
    let(:skeleton) { described_class.new }

    before do
      render_inline(skeleton) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content(content)
      end

      it "has the skeleton class" do
        expect(page).to have_selector(".skeleton")
      end
    end
  end

  context "with hidden text" do
    let(:content) { "Loading..." }
    let(:skeleton) { described_class.new(css: "text-transparent") }

    before do
      render_inline(skeleton) { content }
    end

    describe "rendering" do
      it "includes text-transparent class" do
        expect(page).to have_selector(".skeleton.text-transparent")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".skeleton")
      end

      it "still renders the content" do
        expect(page).to have_content(content)
      end
    end
  end

  context "with multiple classes" do
    let(:classes) { "w-36 h-20 rounded-lg text-transparent" }
    let(:skeleton) { described_class.new(css: classes) }

    before do
      render_inline(skeleton) { "Loading..." }
    end

    describe "rendering" do
      it "includes all classes" do
        classes.split(" ").each do |class_name|
          expect(page).to have_selector(".skeleton.#{class_name}")
        end
      end

      it "maintains default classes" do
        expect(page).to have_selector(".skeleton")
      end
    end
  end

  context "with complex content" do
    let(:skeleton) { described_class.new(css: "w-36") }
    let(:complex_content) do
      content_tag(:div, class: "flex items-center gap-2") do
        content_tag(:span, "Title", class: "font-bold") +
        content_tag(:span, "Description", class: "text-sm")
      end
    end

    before do
      render_inline(skeleton) { complex_content }
    end

    describe "rendering" do
      it "renders the complex content structure" do
        expect(page).to have_selector(".skeleton .flex.items-center.gap-2")
        expect(page).to have_selector(".skeleton .font-bold")
        expect(page).to have_selector(".skeleton .text-sm")
      end

      it "preserves text content" do
        expect(page).to have_content("Title")
        expect(page).to have_content("Description")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".skeleton")
      end
    end
  end
end
