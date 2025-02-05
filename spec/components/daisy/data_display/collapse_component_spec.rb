require "rails_helper"

RSpec.describe Daisy::DataDisplay::CollapseComponent, type: :component do
  context "basic collapse" do
    let(:collapse) { described_class.new(title: "Click to Open") }

    before do
      render_inline(collapse) do
        "This is the content of the collapse."
      end
    end

    describe "rendering" do
      it "has the collapse class" do
        expect(page).to have_selector(".collapse")
      end

      it "renders the title" do
        expect(page).to have_selector(".collapse-title", text: "Click to Open")
      end

      it "renders the content" do
        expect(page).to have_text("This is the content of the collapse.")
      end
    end
  end

  context "with arrow modifier" do
    let(:collapse) { described_class.new(title: "Click to Open", css: "bg-base-100 border border-gray-200 collapse-arrow") }

    before do
      render_inline(collapse) do
        "This is the content of the arrow collapse."
      end
    end

    describe "rendering" do
      it "includes arrow class" do
        expect(page).to have_selector(".collapse.collapse-arrow")
      end

      it "includes background and border classes" do
        expect(page).to have_selector(".collapse.bg-base-100.border.border-gray-200")
      end

      it "renders the content" do
        expect(page).to have_text("This is the content of the arrow collapse.")
      end
    end
  end

  context "with plus modifier" do
    let(:collapse) { described_class.new(title: "Click to Open", css: "bg-base-100 border border-gray-200 collapse-plus") }

    before do
      render_inline(collapse) do
        "This is the content of the plus collapse."
      end
    end

    describe "rendering" do
      it "includes plus class" do
        expect(page).to have_selector(".collapse.collapse-plus")
      end

      it "includes background and border classes" do
        expect(page).to have_selector(".collapse.bg-base-100.border.border-gray-200")
      end

      it "renders the content" do
        expect(page).to have_text("This is the content of the plus collapse.")
      end
    end
  end

  context "with advanced customization" do
    let(:collapse) { described_class.new(css: "collapse-arrow bg-gray-100") }

    before do
      render_inline(collapse) do |c|
        c.with_title(css: "collapse-title bg-gray-300") do
          '<div class="flex gap-x-2 items-center"><svg class="h-6 w-6"></svg><strong>User Profile</strong></div>'.html_safe
        end

        '<div class="mt-4 flex gap-x-4 items-center"><div class="avatar"></div><div><div class="text-xl font-bold">Jane Oliver</div><div class="italic">jane@oliver.test</div></div></div>'.html_safe
      end
    end

    describe "rendering" do
      it "includes custom title classes" do
        expect(page).to have_selector(".collapse-title.bg-gray-300")
      end

      it "renders custom title content" do
        expect(page).to have_selector(".flex.gap-x-2.items-center")
        expect(page).to have_selector("strong", text: "User Profile")
      end

      it "renders custom content" do
        expect(page).to have_selector(".avatar")
        expect(page).to have_selector(".text-xl.font-bold", text: "Jane Oliver")
        expect(page).to have_selector(".italic", text: "jane@oliver.test")
      end
    end
  end

  context "with checkbox" do
    let(:collapse) { described_class.new(checkbox: true, title: "Checkbox Collapse") }

    before do
      render_inline(collapse) do
        "Checkbox collapse content"
      end
    end

    describe "rendering" do
      it "includes checkbox input" do
        expect(page).to have_selector("input[type='checkbox']")
      end

      it "renders title and content" do
        expect(page).to have_selector(".collapse-title", text: "Checkbox Collapse")
        expect(page).to have_text("Checkbox collapse content")
      end
    end
  end

  context "with custom wrapper" do
    let(:collapse) { described_class.new(wrapper_css: "bg-base-200", title: "Wrapped Collapse") }

    before do
      render_inline(collapse) do
        "Wrapped content"
      end
    end

    describe "rendering" do
      it "includes wrapper classes" do
        expect(page).to have_selector(".bg-base-200")
      end

      it "renders title and content" do
        expect(page).to have_selector(".collapse-title", text: "Wrapped Collapse")
        expect(page).to have_text("Wrapped content")
      end
    end
  end
end
