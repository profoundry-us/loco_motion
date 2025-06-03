require "rails_helper"

RSpec.describe Daisy::DataDisplay::CollapseComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  shared_examples "a collapse component" do
    it "has the collapse class" do
      expect(page).to have_selector(".collapse")
    end

    it "renders the content" do
      expect(page).to have_text(content_text)
    end

    it "initially hides the content" do
      expect(page).to have_selector(".collapse-content", visible: false)
    end
  end

  context "basic collapse" do
    let(:content_text) { "This is the content of the collapse." }
    let(:collapse) { described_class.new(title: "Click to Open") }

    before do
      render_inline(collapse) do
        content_text
      end
    end

    describe "rendering" do
      include_examples "a collapse component"

      it "renders the title" do
        expect(page).to have_selector(".collapse-title", text: "Click to Open")
      end
    end
  end

  context "without title" do
    let(:content_text) { "Content without title" }
    let(:collapse) { described_class.new }

    before do
      render_inline(collapse) do
        content_text
      end
    end

    describe "rendering" do
      include_examples "a collapse component"

      it "renders without title" do
        expect(page).not_to have_selector(".collapse-title")
      end
    end
  end

  context "modifiers" do
    context "with arrow" do
      let(:content_text) { "Arrow collapse content" }
      let(:collapse) { described_class.new(title: "Click to Open", css: "bg-base-100 border border-gray-200 collapse-arrow") }

      before do
        render_inline(collapse) do
          content_text
        end
      end

      describe "rendering" do
        include_examples "a collapse component"

        it "includes arrow class" do
          expect(page).to have_selector(".collapse.collapse-arrow")
        end

        it "includes background and border classes" do
          expect(page).to have_selector(".collapse.bg-base-100.border.border-gray-200")
        end
      end
    end

    context "with plus" do
      let(:content_text) { "Plus collapse content" }
      let(:collapse) { described_class.new(title: "Click to Open", css: "bg-base-100 border border-gray-200 collapse-plus") }

      before do
        render_inline(collapse) do
          content_text
        end
      end

      describe "rendering" do
        include_examples "a collapse component"

        it "includes plus class" do
          expect(page).to have_selector(".collapse.collapse-plus")
        end

        it "includes background and border classes" do
          expect(page).to have_selector(".collapse.bg-base-100.border.border-gray-200")
        end
      end
    end
  end

  context "with advanced customization" do
    let(:content_text) { "Jane Oliver" }
    let(:collapse) { described_class.new(css: "collapse-arrow bg-gray-100") }
    let(:title_content) do
      safe_join([
        content_tag(:div, class: "flex gap-x-2 items-center") do
          safe_join([
            content_tag(:svg, "", class: "size-6"),
            content_tag(:strong, "User Profile")
          ])
        end
      ])
    end
    let(:body_content) do
      safe_join([
        content_tag(:div, class: "mt-4 flex gap-x-4 items-center") do
          safe_join([
            content_tag(:div, "", class: "avatar"),
            content_tag(:div) do
              safe_join([
                content_tag(:div, "Jane Oliver", class: "text-xl font-bold"),
                content_tag(:div, "jane@oliver.test", class: "italic")
              ])
            end
          ])
        end
      ])
    end

    before do
      render_inline(collapse) do |c|
        c.with_title(css: "collapse-title bg-gray-300") do
          title_content
        end
        body_content
      end
    end

    describe "rendering" do
      before do
        # Initialize output_buffer for content_tag helper
        @output_buffer = ActionView::OutputBuffer.new
      end

      it_behaves_like "a collapse component" do
        let(:title) do
          content_tag(:div, class: "mt-4 flex gap-x-4 items-center") do
            safe_join([
              content_tag(:div, "", class: "avatar"),
              content_tag(:div) do
                safe_join([
                  content_tag(:div, "Jane Oliver", class: "text-xl font-bold"),
                  content_tag(:div, "jane@oliver.test", class: "italic")
                ])
              end
            ])
          end
        end
      end

      it "includes custom title classes" do
        expect(page).to have_selector(".collapse-title.bg-gray-300")
      end

      it "renders custom title content" do
        expect(page).to have_selector(".flex.gap-x-2.items-center")
        expect(page).to have_selector("strong", text: "User Profile")
      end

      it "renders custom content" do
        expect(page).to have_selector(".avatar")
        expect(page).to have_selector(".text-xl.font-bold", text: "Jane Oliver")
        expect(page).to have_selector(".italic", text: "jane@oliver.test")
      end
    end
  end

  context "with checkbox" do
    let(:content_text) { "Checkbox collapse content" }
    let(:collapse) { described_class.new(checkbox: true, title: "Checkbox Collapse") }

    before do
      render_inline(collapse) do
        content_text
      end
    end

    describe "rendering" do
      include_examples "a collapse component"

      it "includes checkbox input" do
        expect(page).to have_selector("input[type='checkbox']")
      end

      it "renders title and content" do
        expect(page).to have_selector(".collapse-title", text: "Checkbox Collapse")
      end
    end
  end

  context "with custom wrapper" do
    let(:content_text) { "Wrapped content" }
    let(:collapse) { described_class.new(wrapper_css: "bg-base-200", title: "Wrapped Collapse") }

    before do
      render_inline(collapse) do
        content_text
      end
    end

    describe "rendering" do
      include_examples "a collapse component"

      it "includes wrapper classes" do
        expect(page).to have_selector(".bg-base-200")
      end

      it "renders title and content" do
        expect(page).to have_selector(".collapse-title", text: "Wrapped Collapse")
      end
    end
  end
end
