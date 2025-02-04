require "rails_helper"

RSpec.describe Daisy::Feedback::RadialProgressComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "with value" do
    let(:value) { 66 }
    let(:content) { "#{value}%" }
    let(:radial) { described_class.new(value: value) }

    before do
      render_inline(radial) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content(content)
      end

      it "has the radial-progress class" do
        expect(page).to have_selector(".radial-progress")
      end

      it "has the progressbar role" do
        expect(page).to have_selector("[role='progressbar']")
      end

      it "sets the value style" do
        expect(page).to have_selector("[style*='--value: #{value}']")
      end
    end
  end

  context "with custom size" do
    let(:size) { "15rem" }
    let(:radial) { described_class.new(value: 42, size: size) }

    before do
      render_inline(radial) { "42%" }
    end

    describe "rendering" do
      it "sets the size style" do
        expect(page).to have_selector("[style*='--size: #{size}']")
      end
    end
  end

  context "with custom thickness" do
    let(:thickness) { "4px" }
    let(:radial) { described_class.new(value: 42, thickness: thickness) }

    before do
      render_inline(radial) { "42%" }
    end

    describe "rendering" do
      it "sets the thickness style" do
        expect(page).to have_selector("[style*='--thickness: #{thickness}']")
      end
    end
  end

  context "with multiple custom styles" do
    let(:value) { 19 }
    let(:size) { "15rem" }
    let(:thickness) { "4px" }
    let(:radial) { described_class.new(value: value, size: size, thickness: thickness) }

    before do
      render_inline(radial) { "#{value}%" }
    end

    describe "rendering" do
      it "sets all style properties" do
        expect(page).to have_selector("[style*='--value: #{value}']")
        expect(page).to have_selector("[style*='--size: #{size}']")
        expect(page).to have_selector("[style*='--thickness: #{thickness}']")
      end

      it "combines styles with semicolons" do
        styles = page.find(".radial-progress")[:style]
        expect(styles.split(";").length).to eq(3)
      end
    end
  end

  context "with custom CSS classes" do
    let(:custom_classes) { "bg-primary text-primary-content text-3xl" }
    let(:radial) { described_class.new(value: 42, css: custom_classes) }

    before do
      render_inline(radial) { "42%" }
    end

    describe "rendering" do
      it "includes custom classes" do
        custom_classes.split(" ").each do |class_name|
          expect(page).to have_selector(".radial-progress.#{class_name}")
        end
      end

      it "maintains default classes" do
        expect(page).to have_selector(".radial-progress")
      end
    end
  end

  context "with complex content" do
    let(:radial) { described_class.new(value: 68) }
    let(:icon) { content_tag(:svg, "", class: "size-8 text-purple-500", data: { slot: "icon" }) }

    before do
      render_inline(radial) { icon }
    end

    describe "rendering" do
      it "renders the icon" do
        expect(page).to have_selector(".radial-progress svg.size-8.text-purple-500")
      end
    end
  end

  context "with zero value" do
    let(:radial) { described_class.new(value: 0) }

    before do
      render_inline(radial) { "0%" }
    end

    describe "rendering" do
      it "sets the value style to 0" do
        expect(page).to have_selector("[style*='--value: 0']")
      end
    end
  end

  context "with full value" do
    let(:radial) { described_class.new(value: 100) }

    before do
      render_inline(radial) { "100%" }
    end

    describe "rendering" do
      it "sets the value style to 100" do
        expect(page).to have_selector("[style*='--value: 100']")
      end
    end
  end

  context "without value" do
    let(:radial) { described_class.new }

    before do
      render_inline(radial) { "Loading..." }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content("Loading...")
      end

      it "has the radial-progress class" do
        expect(page).to have_selector(".radial-progress")
      end

      it "has the progressbar role" do
        expect(page).to have_selector("[role='progressbar']")
      end

      it "does not set any styles" do
        expect(page).not_to have_selector("[style]")
      end
    end
  end
end
