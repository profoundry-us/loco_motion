require "rails_helper"

RSpec.describe Daisy::Actions::ModalComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper

  context "with no options" do
    let(:modal) { described_class.new }

    before do
      render_inline(modal)
    end

    describe "setup" do
      it "sets closable to true" do
        expect(modal.closable).to eq(true)
      end

      it "sets the dialog_id" do
        expect(modal.dialog_id).to be_present
      end
    end

    describe "rendering" do
      it "renders the dialog" do
        expect(page).to have_css "dialog.modal"
      end

      it "renders the modal box" do
        expect(page).to have_css "dialog.modal .modal-box"
      end

      it "does not add an extra 'modal' class to the modal-box" do
        expect(page).not_to have_css "dialog.modal .modal.modal-box"
      end

      it "renders the standard close icon" do
        expect(page).to have_selector("dialog.modal svg[data-slot='icon']")
      end
    end
  end

  context "with a custom close icon" do
    let(:modal) { described_class.new }

    before do
      render_inline(modal) do |m|
        m.with_close_icon do
          content_tag(:span, "!", class: 'custom-icon')
        end
      end
    end

    describe "close_icon?" do
      it "returns true" do
        expect(modal.close_icon?).to be_truthy
      end
    end

    describe "rendering" do
      it "renders our custom icon" do
        expect(page).to have_selector("dialog.modal .custom-icon")
      end

      it "does not render the standard close icon" do
        expect(page).not_to have_selector("dialog.modal svg[data-slot='icon']")
      end
    end
  end

  context "when closable is false" do
    let(:modal) { described_class.new(closable: false) }

    before do
      render_inline(modal)
    end

    describe "rendering" do
      it "does not render the close icon" do
        expect(page).not_to have_css "dialog.modal .btn-circle"
      end

      it "does not add the closable class" do
        expect(page).not_to have_css "dialog.modal.modal-closable"
      end
    end
  end

  context "with custom content" do
    let(:modal) { described_class.new }
    let(:content) { "Custom Content" }

    before do
      render_inline(modal) { content_tag(:div, content, class: "custom-content") }
    end

    describe "rendering" do
      it "renders the custom content" do
        expect(page).to have_selector(".modal .modal-box .custom-content")
        expect(page).to have_content content
      end
    end
  end

  context "with a title" do
    let(:title) { "Important Message" }
    let(:modal) { described_class.new(title: title) }

    before do
      render_inline(modal)
    end

    describe "rendering" do
      it "renders the title" do
        expect(page).to have_content title
      end

      it "renders the title in the correct container" do
        expect(page).to have_selector(".modal .modal-box", text: title)
      end
    end
  end

  context "with a title and simple_title" do
    let(:title) { "Important Message" }
    let(:modal) { described_class.new(title: title, simple_title: true) }

    before do
      render_inline(modal)
    end

    describe "rendering" do
      it "renders only the content title" do
        expect(page).to have_content title
      end

      it "renders the content title in the correct container" do
        expect(page).to have_selector("dialog.modal .modal-box", text: title)
      end
    end
  end

  context "with custom CSS classes" do
    let(:modal) { described_class.new(css: "custom-modal large-size") }

    before do
      render_inline(modal)
    end

    describe "rendering" do
      it "includes the custom classes" do
        expect(page).to have_css "dialog.modal.custom-modal.large-size"
      end
    end
  end

  context "with form content" do
    let(:modal) { described_class.new }
    let(:form_html) do
      <<~HTML.html_safe
        <form action="/submit" method="post">
          <input type="text" name="name" id="name" />
          <input type="submit" value="Submit" />
        </form>
      HTML
    end

    before do
      render_inline(modal) do |m|
        m.with_end_actions { form_html }
      end
    end

    describe "rendering" do
      it "renders the form" do
        expect(page).to have_selector("dialog .modal-box form[action='/submit']")
        expect(page).to have_field "name"
        expect(page).to have_button "Submit"
      end

      it "maintains proper nesting" do
        expect(page).to have_selector("dialog .modal-box form")
      end
    end
  end
end
