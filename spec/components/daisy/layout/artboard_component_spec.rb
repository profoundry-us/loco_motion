require "rails_helper"

RSpec.describe Daisy::Layout::ArtboardComponent, type: :component do
  context "basic artboard" do
    let(:artboard) { described_class.new }

    before do
      render_inline(artboard) do
        "Artboard Content"
      end
    end

    describe "rendering" do
      it "has the artboard class" do
        expect(page).to have_selector(".artboard")
      end

      it "renders the content" do
        expect(page).to have_text("Artboard Content")
      end
    end
  end

  context "with phone sizes" do
    {
      "phone-1" => [320, 568],
      "phone-2" => [375, 667],
      "phone-3" => [414, 736],
      "phone-4" => [375, 812],
      "phone-5" => [414, 896],
      "phone-6" => [320, 1024]
    }.each do |phone_name, (width, height)|
      context "with #{phone_name}" do
        let(:artboard) { described_class.new(css: phone_name) }

        before do
          render_inline(artboard) do
            "#{width}×#{height}"
          end
        end

        describe "rendering" do
          it "applies the phone size class" do
            expect(page).to have_selector(".artboard.#{phone_name}")
          end

          it "renders the content" do
            expect(page).to have_text("#{width}×#{height}")
          end
        end
      end
    end
  end

  context "with horizontal orientation" do
    let(:artboard) { described_class.new(css: "artboard-horizontal phone-1") }

    before do
      render_inline(artboard) do
        "568×320"
      end
    end

    describe "rendering" do
      it "applies the horizontal class" do
        expect(page).to have_selector(".artboard.artboard-horizontal")
      end

      it "applies the phone size class" do
        expect(page).to have_selector(".artboard.phone-1")
      end

      it "renders the content" do
        expect(page).to have_text("568×320")
      end
    end
  end

  context "with demo styling" do
    let(:artboard) { described_class.new(css: "artboard-demo") }

    before do
      render_inline(artboard) do
        "Demo Content"
      end
    end

    describe "rendering" do
      it "applies the demo class" do
        expect(page).to have_selector(".artboard.artboard-demo")
      end
    end
  end
end
