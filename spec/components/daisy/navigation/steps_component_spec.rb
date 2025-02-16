require "rails_helper"

RSpec.describe Daisy::Navigation::StepsComponent, type: :component do
  context "basic steps" do
    let(:steps) { described_class.new }

    before do
      render_inline(steps) do |s|
        s.with_step(title: "Write Code", css: "step-primary")
        s.with_step(title: "Release Code", css: "step-primary")
        s.with_step(title: "Profit", css: "step-secondary")
        s.with_step(title: "Rule the World")
      end
    end

    describe "rendering" do
      it "has the steps class" do
        expect(page).to have_selector(".steps")
      end

      it "renders as an unordered list" do
        expect(page).to have_selector("ul.steps")
      end

      it "renders all steps" do
        expect(page).to have_selector(".step", count: 4)
      end

      it "renders step titles" do
        expect(page).to have_selector(".step", text: "Write Code")
        expect(page).to have_selector(".step", text: "Release Code")
        expect(page).to have_selector(".step", text: "Profit")
        expect(page).to have_selector(".step", text: "Rule the World")
      end

      it "applies step colors" do
        expect(page).to have_selector(".step.step-primary", count: 2)
        expect(page).to have_selector(".step.step-secondary", count: 1)
      end
    end
  end

  context "vertical steps" do
    let(:steps) { described_class.new(css: "steps-vertical") }

    before do
      render_inline(steps) do |s|
        s.with_step(title: "Step 1")
        s.with_step(title: "Step 2")
      end
    end

    describe "rendering" do
      it "includes vertical orientation class" do
        expect(page).to have_selector(".steps.steps-vertical")
      end

      it "renders steps vertically" do
        expect(page).to have_selector(".steps-vertical .step", count: 2)
      end
    end
  end

  context "with custom content" do
    let(:steps) { described_class.new }

    before do
      render_inline(steps) do |s|
        s.with_step(number: "AB")
        s.with_step(number: "CD")
        s.with_step(number: "★")
        s.with_step(number: "✓")
        s.with_step(number: "✕", css: "after:!bg-black after:!text-green-500")
      end
    end

    describe "rendering" do
      it "sets custom step numbers" do
        expect(page).to have_selector(".step[data-content='AB']")
        expect(page).to have_selector(".step[data-content='CD']")
        expect(page).to have_selector(".step[data-content='★']")
        expect(page).to have_selector(".step[data-content='✓']")
        expect(page).to have_selector(".step[data-content='✕']")
      end

      it "applies custom styles" do
        step = page.find(".step[data-content='✕']")
        expect(step[:class]).to include("after:!bg-black")
        expect(step[:class]).to include("after:!text-green-500")
      end
    end
  end

  context "with complex content" do
    let(:steps) { described_class.new }

    before do
      render_inline(steps) do |s|
        s.with_step do
          '<div class="flex items-center"><span class="mr-2">✓</span>Done</div>'.html_safe
        end
      end
    end

    describe "rendering" do
      it "renders complex content" do
        expect(page).to have_selector(".step .flex.items-center")
        expect(page).to have_selector(".step .mr-2", text: "✓")
        expect(page).to have_content("Done")
      end
    end
  end

  context "with data attributes" do
    let(:steps) { described_class.new }

    before do
      render_inline(steps) do |s|
        s.with_step(html: { data: { content: "❤️" } })
      end
    end

    describe "rendering" do
      it "sets data attributes" do
        expect(page).to have_selector(".step[data-content='❤️']")
      end
    end
  end

  context "with custom CSS" do
    let(:steps) { described_class.new(css: "steps-horizontal") }

    before do
      render_inline(steps) do |s|
        s.with_step(title: "Step", css: "step-lg")
      end
    end

    describe "rendering" do
      it "includes custom container classes" do
        expect(page).to have_selector(".steps.steps-horizontal")
      end

      it "includes custom step classes" do
        expect(page).to have_selector(".step.step-lg")
      end
    end
  end
end
