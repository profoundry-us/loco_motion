require "rails_helper"

RSpec.describe Daisy::Feedback::ProgressComponent, type: :component do
  context "with value" do
    let(:value) { 42 }
    let(:progress) { described_class.new(value: value) }

    before do
      render_inline(progress)
    end

    describe "rendering" do
      it "renders a progress element" do
        expect(page).to have_selector("progress")
      end

      it "has the progress class" do
        expect(page).to have_selector(".progress")
      end

      it "sets the value attribute" do
        expect(page).to have_selector("progress[value='#{value}']")
      end

      it "sets the default max attribute" do
        expect(page).to have_selector("progress[max='100']")
      end
    end
  end

  context "with custom max" do
    let(:value) { 5 }
    let(:max) { 10 }
    let(:progress) { described_class.new(value: value, max: max) }

    before do
      render_inline(progress)
    end

    describe "rendering" do
      it "sets the custom max attribute" do
        expect(page).to have_selector("progress[max='#{max}']")
      end

      it "sets the value attribute" do
        expect(page).to have_selector("progress[value='#{value}']")
      end
    end
  end

  context "indeterminate progress" do
    let(:progress) { described_class.new }

    before do
      render_inline(progress)
    end

    describe "rendering" do
      it "renders a progress element" do
        expect(page).to have_selector("progress.progress")
      end

      it "does not set the value attribute" do
        expect(page).not_to have_selector("progress[value]")
      end

      it "does not set the max attribute" do
        expect(page).not_to have_selector("progress[max]")
      end
    end
  end

  context "with custom CSS classes" do
    {
      "primary" => "progress-primary",
      "secondary" => "progress-secondary",
      "accent" => "progress-accent",
      "info" => "progress-info",
      "success" => "progress-success",
      "warning" => "progress-warning",
      "error" => "progress-error"
    }.each do |type, class_name|
      context "with #{type} type" do
        let(:progress) { described_class.new(css: class_name) }

        before do
          render_inline(progress)
        end

        describe "rendering" do
          it "includes the custom class" do
            expect(page).to have_selector(".progress.#{class_name}")
          end

          it "maintains default classes" do
            expect(page).to have_selector(".progress")
          end
        end
      end
    end
  end

  context "with animation delay" do
    let(:progress) { described_class.new(css: "![animation-delay:250ms]") }

    before do
      render_inline(progress)
    end

    describe "rendering" do
      it "includes the animation delay class" do
        expect(page).to have_selector(".progress.\\!\\[animation-delay\\:250ms\\]")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".progress")
      end
    end
  end

  context "with zero value" do
    let(:progress) { described_class.new(value: 0) }

    before do
      render_inline(progress)
    end

    describe "rendering" do
      it "sets the value attribute to 0" do
        expect(page).to have_selector("progress[value='0']")
      end

      it "sets the default max attribute" do
        expect(page).to have_selector("progress[max='100']")
      end
    end
  end

  context "with full value" do
    let(:progress) { described_class.new(value: 100) }

    before do
      render_inline(progress)
    end

    describe "rendering" do
      it "sets the value attribute to 100" do
        expect(page).to have_selector("progress[value='100']")
      end

      it "sets the default max attribute" do
        expect(page).to have_selector("progress[max='100']")
      end
    end
  end
end
