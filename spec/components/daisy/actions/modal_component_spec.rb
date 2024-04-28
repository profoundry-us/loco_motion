require "rails_helper"

RSpec.describe Daisy::Actions::ModalComponent, type: :component do
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
        expect(page).to have_css ".modal .modal-box"
      end

      it "does not add an extra 'modal' class to the modal-box" do
        expect(page).not_to have_css ".modal .modal.modal-box"
      end

      it "renders the standard close icon" do
        expect(page).to have_selector(".modal svg[data-slot='icon']")
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
        expect(page).to have_selector(".modal .custom-icon")
      end

      it "does not render the standard close icon" do
        expect(page).not_to have_selector(".modal svg[data-slot='icon']")
      end
    end
  end
end
