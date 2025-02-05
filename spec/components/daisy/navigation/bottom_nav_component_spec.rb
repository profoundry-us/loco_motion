require "rails_helper"

RSpec.describe Daisy::Navigation::BottomNavComponent, type: :component do
  context "basic bottom nav" do
    let(:nav) { described_class.new }

    before do
      render_inline(nav) do |n|
        n.with_section(icon: "home", href: "#")
        n.with_section(icon: "information-circle", href: "#", active: true)
        n.with_section(icon: "chart-bar", href: "#")
      end
    end

    describe "rendering" do
      it "has the btm-nav class" do
        expect(page).to have_selector(".btm-nav")
      end

      it "renders all sections" do
        expect(page).to have_selector(".btm-nav > a", count: 3)
      end

      it "renders icons" do
        expect(page).to have_selector("svg", count: 3)
      end

      it "sets href attributes" do
        expect(page).to have_selector("a[href='#']", count: 3)
      end

      it "marks active section" do
        expect(page).to have_selector("a.active", count: 1)
        expect(page).to have_selector("a.active svg")
      end

      it "sets default icon size" do
        expect(page).to have_selector("[class*='size-6']", count: 3)
      end
    end
  end

  context "with titles" do
    let(:nav) { described_class.new }

    before do
      render_inline(nav) do |n|
        n.with_section(icon: "home", href: "#", title: "Home")
        n.with_section(icon: "information-circle", href: "#", title: "Info")
        n.with_section(icon: "chart-bar", href: "#") do
          '<div class="font-bold text-xs">Stats</div>'.html_safe
        end
      end
    end

    describe "rendering" do
      it "renders simple titles" do
        expect(page).to have_selector(".btm-nav-label", text: "Home")
        expect(page).to have_selector(".btm-nav-label", text: "Info")
      end

      it "renders complex title content" do
        expect(page).to have_selector(".font-bold.text-xs", text: "Stats")
      end
    end
  end

  context "with custom icon styles" do
    let(:nav) { described_class.new }

    before do
      render_inline(nav) do |n|
        n.with_section(
          icon: "information-circle",
          icon_css: "text-blue-600 -rotate-45",
          href: "#"
        )
      end
    end

    describe "rendering" do
      it "applies custom icon styles" do
        icon = page.find("svg")
        expect(icon[:class]).to include("text-blue-600")
        expect(icon[:class]).to include("-rotate-45")
      end
    end
  end

  context "with custom colors" do
    let(:nav) { described_class.new }

    before do
      render_inline(nav) do |n|
        n.with_section(icon: "home", href: "#", css: "text-primary")
        n.with_section(icon: "chart-bar", href: "#", css: "text-[#449944]")
      end
    end

    describe "rendering" do
      it "applies theme colors" do
        expect(page).to have_selector(".text-primary")
      end

      it "applies custom hex colors" do
        expect(page).to have_selector(".text-\\[\\#449944\\]")
      end
    end
  end

  context "with buttons instead of links" do
    let(:nav) { described_class.new }

    before do
      render_inline(nav) do |n|
        n.with_section(icon: "home")
        n.with_section(icon: "chart-bar", active: true)
      end
    end

    describe "rendering" do
      it "renders as buttons when no href is provided" do
        expect(page).to have_selector("button", count: 2)
      end

      it "marks active button" do
        expect(page).to have_selector("button.active svg")
      end
    end
  end

  context "with custom icon variant" do
    let(:nav) { described_class.new }

    before do
      render_inline(nav) do |n|
        n.with_section(icon: "home", icon_variant: :solid)
      end
    end

    describe "rendering" do
      it "uses specified icon variant" do
        expect(page).to have_selector("svg")
      end
    end
  end

  context "with custom container styles" do
    let(:nav) { described_class.new(css: "relative border border-base-200") }

    before do
      render_inline(nav) do |n|
        n.with_section(icon: "home")
      end
    end

    describe "rendering" do
      it "includes custom container classes" do
        expect(page).to have_selector(".btm-nav.relative.border.border-base-200")
      end
    end
  end
end
