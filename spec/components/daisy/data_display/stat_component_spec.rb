require "rails_helper"

RSpec.describe Daisy::DataDisplay::StatComponent, type: :component do
  context "basic stat" do
    let(:stat) { described_class.new }

    before do
      render_inline(stat) do
        "$8,619.45"
      end
    end

    describe "rendering" do
      it "has the stat class" do
        expect(page).to have_selector(".stat")
      end

      it "renders the value" do
        expect(page).to have_selector(".stat-value", text: "$8,619.45")
      end
    end
  end

  context "with simple title and description" do
    let(:stat) { described_class.new(title: "Views", description: "Views in the last 24 hours.") }

    before do
      render_inline(stat) do
        "1,208"
      end
    end

    describe "rendering" do
      it "renders the title" do
        expect(page).to have_selector(".stat-title", text: "Views")
      end

      it "renders the value" do
        expect(page).to have_selector(".stat-value", text: "1,208")
      end

      it "renders the description" do
        expect(page).to have_selector(".stat-desc", text: "Views in the last 24 hours.")
      end
    end
  end

  context "with complex title and description" do
    let(:stat) { described_class.new }

    before do
      @result = render_inline(stat) do |s|
        s.with_title { "<div><p class='font-bold'>Average Cart Value</p></div>".html_safe }
        s.with_description { "<div><p class='text-success'>You're doing quite well on your ACV!</p></div>".html_safe }
        "$319"
      end
    end

    describe "rendering" do
      it "renders the complex title" do
        expect(page).to have_css("div div p.font-bold", text: "Average Cart Value")
      end

      it "renders the value" do
        expect(page).to have_css(".stat-value", text: "$319")
      end

      it "renders the complex description" do
        expect(page).to have_css("div div p.text-success", text: "You're doing quite well on your ACV!")
      end
    end
  end

  context "with figure" do
    context "with image" do
      let(:stat) { described_class.new(src: "avatars/lady-smiling-1.jpg") }

      before do
        render_inline(stat) do
          "25"
        end
      end

      describe "rendering" do
        it "renders the figure" do
          expect(page).to have_selector(".stat-figure")
        end

        it "renders the image" do
          expect(page).to have_selector(".stat-figure img[src='avatars/lady-smiling-1.jpg']")
        end
      end
    end

    context "with icon" do
      let(:stat) { described_class.new(icon: "academic-cap") }

      before do
        render_inline(stat) do
          "1,112"
        end
      end

      describe "rendering" do
        it "renders the figure" do
          expect(page).to have_selector(".stat-figure")
        end

        it "renders the icon" do
          expect(page).to have_selector(".stat-figure svg")
        end
      end
    end

    context "with custom figure" do
      let(:stat) { described_class.new }

      before do
        render_inline(stat) do |s|
          s.with_figure do
            "<div class='bg-primary rounded-full p-2'>★</div>".html_safe
          end

          "42"
        end
      end

      describe "rendering" do
        it "renders the custom figure" do
          expect(page).to have_selector(".stat-figure .bg-primary.rounded-full", text: "★")
        end
      end
    end
  end

  context "with custom styling" do
    let(:stat) { described_class.new(css: "max-w-80") }

    before do
      render_inline(stat) do
        "100"
      end
    end

    describe "rendering" do
      it "includes custom container classes" do
        expect(page).to have_selector(".stat.max-w-80")
      end
    end
  end

  context "with tooltip" do
    let(:stat) { described_class.new(tip: "This is a tooltip") }

    before do
      render_inline(stat) do
        "42"
      end
    end

    describe "rendering" do
      it "includes tooltip class" do
        expect(page).to have_selector(".stat.tooltip")
      end

      it "sets tooltip content" do
        expect(page).to have_selector(".stat[data-tip='This is a tooltip']")
      end
    end
  end
end
