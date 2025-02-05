require "rails_helper"

RSpec.describe Daisy::Mockup::DeviceComponent, type: :component do
  context "basic device" do
    let(:device) { described_class.new(css: "mockup-phone") }

    before do
      render_inline(device) do
        "Content"
      end
    end

    describe "rendering" do
      it "renders as a device" do
        expect(page).to have_selector(".mockup-phone")
      end

      it "renders the content" do
        expect(page).to have_text("Content")
      end
    end
  end

  context "with phone mockup" do
    let(:device) { described_class.new(css: "mockup-phone") }

    before do
      render_inline(device) do
        "Phone Content"
      end
    end

    describe "rendering" do
      it "applies the phone mockup class" do
        expect(page).to have_selector(".mockup-phone")
      end

      it "renders the camera by default" do
        expect(page).to have_selector(".camera")
      end

      it "renders the content" do
        expect(page).to have_text("Phone Content")
      end
    end
  end

  context "without camera" do
    let(:device) { described_class.new(show_camera: false) }

    before do
      render_inline(device) do
        "Content"
      end
    end

    describe "rendering" do
      it "does not render the camera" do
        expect(page).not_to have_selector(".camera")
      end

      it "renders the content" do
        expect(page).to have_text("Content")
      end
    end
  end

  context "with custom styling" do
    let(:device) { described_class.new(css: "mockup-phone border-red-600") }

    before do
      render_inline(device) do
        "Styled Content"
      end
    end

    describe "rendering" do
      it "applies custom CSS classes" do
        expect(page).to have_selector(".mockup-phone.border-red-600")
      end
    end
  end
end
