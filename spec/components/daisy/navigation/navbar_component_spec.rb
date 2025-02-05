require "rails_helper"

RSpec.describe Daisy::Navigation::NavbarComponent, type: :component do
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper

  context "basic navbar" do
    let(:navbar) { described_class.new }

    before do
      render_inline(navbar)
    end

    describe "rendering" do
      it "has the navbar class" do
        expect(page).to have_selector(".navbar")
      end
    end
  end

  context "with start section" do
    let(:navbar) { described_class.new }

    before do
      render_inline(navbar) do |n|
        n.with_start { "Start Content" }
      end
    end

    describe "rendering" do
      it "renders the start section" do
        expect(page).to have_selector(".navbar-start", text: "Start Content")
      end

      it "maintains proper section order" do
        expect(page).to have_selector(".navbar > .navbar-start:first-child")
      end
    end
  end

  context "with center section" do
    let(:navbar) { described_class.new }

    before do
      render_inline(navbar) do |n|
        n.with_center { "Center Content" }
      end
    end

    describe "rendering" do
      it "renders the center section" do
        expect(page).to have_selector(".navbar-center", text: "Center Content")
      end
    end
  end

  context "with tail section" do
    let(:navbar) { described_class.new }

    before do
      render_inline(navbar) do |n|
        n.with_tail { "End Content" }
      end
    end

    describe "rendering" do
      it "renders the tail section" do
        expect(page).to have_selector(".navbar-end", text: "End Content")
      end

      it "maintains proper section order" do
        expect(page).to have_selector(".navbar > .navbar-end:last-child")
      end
    end
  end

  context "with all sections" do
    let(:navbar) { described_class.new }

    before do
      render_inline(navbar) do |n|
        n.with_start { "Start Content" }
        n.with_center { "Center Content" }
        n.with_tail { "End Content" }
      end
    end

    describe "rendering" do
      it "renders all sections" do
        expect(page).to have_selector(".navbar-start", text: "Start Content")
        expect(page).to have_selector(".navbar-center", text: "Center Content")
        expect(page).to have_selector(".navbar-end", text: "End Content")
      end

      it "maintains proper section order" do
        sections = page.all(".navbar > *").map { |el| el[:class] }
        expect(sections).to eq(["navbar-start", "navbar-center", "navbar-end"])
      end
    end
  end

  context "with custom CSS" do
    let(:navbar) { described_class.new(css: "bg-base-200 rounded-lg") }

    before do
      render_inline(navbar) do |n|
        n.with_start { "Content" }
      end
    end

    describe "rendering" do
      it "includes custom navbar classes" do
        expect(page).to have_selector(".navbar.bg-base-200.rounded-lg")
      end

      it "maintains default navbar class" do
        expect(page).to have_selector(".navbar")
      end
    end
  end

  context "with complex content" do
    let(:navbar) { described_class.new }

    before do
      render_inline(navbar) do |n|
        n.with_start do
          '<div class="flex items-center"><button class="btn btn-ghost">Menu</button><a href="#" class="btn btn-ghost text-xl">Brand</a></div>'.html_safe
        end

        n.with_center do
          '<div class="form-control"><input type="text" placeholder="Search..." class="input input-bordered"></div>'.html_safe
        end

        n.with_tail do
          '<button class="btn btn-primary">Login</button>'.html_safe
        end
      end
    end

    describe "rendering" do
      it "renders complex start content" do
        expect(page).to have_selector(".navbar-start .btn.btn-ghost", text: "Menu")
        expect(page).to have_selector(".navbar-start a.btn.btn-ghost.text-xl", text: "Brand")
      end

      it "renders complex center content" do
        expect(page).to have_selector(".navbar-center input[type='text'].input.input-bordered[placeholder='Search...']")
      end

      it "renders complex tail content" do
        expect(page).to have_selector(".navbar-end .btn.btn-primary", text: "Login")
      end

      it "maintains proper structure with complex content" do
        expect(page).to have_selector(".navbar > .navbar-start > .flex.items-center")
        expect(page).to have_selector(".navbar > .navbar-center > .form-control")
        expect(page).to have_selector(".navbar > .navbar-end > .btn.btn-primary")
      end
    end
  end
end
