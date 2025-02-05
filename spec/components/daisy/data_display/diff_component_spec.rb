require "rails_helper"

RSpec.describe Daisy::DataDisplay::DiffComponent, type: :component do
  context "basic diff" do
    let(:diff) { described_class.new }

    before do
      render_inline(diff) do |d|
        d.with_item do
          "<div class='bg-primary'>First Item</div>".html_safe
        end

        d.with_item do
          "<div class='bg-base-200'>Second Item</div>".html_safe
        end
      end
    end

    describe "rendering" do
      it "has the diff class" do
        expect(page).to have_selector(".diff")
      end

      it "renders both items" do
        expect(page).to have_selector(".diff-item-1", text: "First Item")
        expect(page).to have_selector(".diff-item-2", text: "Second Item")
      end

      it "applies background colors" do
        expect(page).to have_selector(".bg-primary")
        expect(page).to have_selector(".bg-base-200")
      end

      it "includes a resizer" do
        expect(page).to have_selector(".diff-resizer")
      end
    end
  end

  context "with custom styling" do
    let(:diff) { described_class.new(css: "aspect-video max-w-[800px] max-h-[450px]") }

    before do
      render_inline(diff) do |d|
        d.with_item do
          "<div class='text-6xl'>First Item</div>".html_safe
        end

        d.with_item do
          "<div class='text-8xl'>Second Item</div>".html_safe
        end
      end
    end

    describe "rendering" do
      it "includes custom container classes" do
        expect(page).to have_selector(".diff.aspect-video.max-w-\\[800px\\].max-h-\\[450px\\]")
      end

      it "renders items with different text sizes" do
        expect(page).to have_selector(".text-6xl", text: "First Item")
        expect(page).to have_selector(".text-8xl", text: "Second Item")
      end
    end
  end

  context "with images" do
    let(:diff) { described_class.new }

    before do
      render_inline(diff) do |d|
        d.with_item do
          "<img src='image1.jpg' alt='Image 1'>".html_safe
        end

        d.with_item do
          "<img src='image2.jpg' alt='Image 2' class='blur'>".html_safe
        end
      end
    end

    describe "rendering" do
      it "renders images" do
        expect(page).to have_selector(".diff-item-1 img[src='image1.jpg']")
        expect(page).to have_selector(".diff-item-2 img[src='image2.jpg']")
      end

      it "applies image effects" do
        expect(page).to have_selector(".diff-item-2 img.blur")
      end
    end
  end
end
