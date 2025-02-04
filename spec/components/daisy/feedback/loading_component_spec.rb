require "rails_helper"

RSpec.describe Daisy::Feedback::LoadingComponent, type: :component do
  context "basic loader" do
    let(:loading) { described_class.new }

    before do
      render_inline(loading)
    end

    describe "rendering" do
      it "has the loading class" do
        expect(page).to have_selector(".loading")
      end
    end
  end

  context "with loader types" do
    {
      spinner: "loading-spinner",
      dots: "loading-dots",
      ring: "loading-ring",
      ball: "loading-ball",
      bars: "loading-bars",
      infinity: "loading-infinity"
    }.each do |type, class_name|
      context "with #{type} type" do
        let(:loading) { described_class.new(css: class_name) }

        before do
          render_inline(loading)
        end

        describe "rendering" do
          it "includes the type class" do
            expect(page).to have_selector(".loading.#{class_name}")
          end

          it "maintains default classes" do
            expect(page).to have_selector(".loading")
          end
        end
      end
    end
  end

  context "with colors" do
    {
      primary: "text-primary",
      secondary: "text-secondary",
      accent: "text-accent",
      info: "text-info",
      success: "text-success",
      error: "text-error"
    }.each do |color, class_name|
      context "with #{color} color" do
        let(:loading) { described_class.new(css: class_name) }

        before do
          render_inline(loading)
        end

        describe "rendering" do
          it "includes the color class" do
            expect(page).to have_selector(".loading.#{class_name}")
          end

          it "maintains default classes" do
            expect(page).to have_selector(".loading")
          end
        end
      end
    end
  end

  context "with multiple classes" do
    let(:loading) { described_class.new(css: "loading-spinner text-primary") }

    before do
      render_inline(loading)
    end

    describe "rendering" do
      it "includes all classes" do
        expect(page).to have_selector(".loading.loading-spinner.text-primary")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".loading")
      end
    end
  end

  context "with tooltip" do
    let(:tip) { "Loading..." }
    let(:loading) { described_class.new(tip: tip) }

    before do
      render_inline(loading)
    end

    describe "rendering" do
      it "includes the tooltip class" do
        expect(page).to have_selector(".loading.tooltip")
      end

      it "sets the data-tip attribute" do
        expect(page).to have_selector("[data-tip='#{tip}']")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".loading")
      end
    end
  end

  context "with tooltip and other classes" do
    let(:loading) { described_class.new(tip: "Loading...", css: "loading-spinner text-primary") }

    before do
      render_inline(loading)
    end

    describe "rendering" do
      it "includes all classes" do
        expect(page).to have_selector(".loading.loading-spinner.text-primary.tooltip")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".loading")
      end

      it "sets the data-tip attribute" do
        expect(page).to have_selector("[data-tip='Loading...']")
      end
    end
  end
end
