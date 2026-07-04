# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::Actions::ButtonComponent, type: :component do
  context "with no options" do
    let(:button) { described_class.new }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "renders a button tag" do
        expect(page).to have_css "button.btn"
      end

      it "uses 'Submit' as default title" do
        expect(page).to have_button "Submit"
      end
    end
  end

  context "with a title string" do
    let(:button) { described_class.new("Click Me") }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "renders the provided title" do
        expect(page).to have_button "Click Me"
      end
    end
  end

  context "with block content" do
    let(:button) { described_class.new }

    before do
      render_inline(button) { "Custom Content" }
    end

    describe "rendering" do
      it "renders the block content" do
        expect(page).to have_button "Custom Content"
      end
    end
  end

  context "with icons" do
    describe "with a single icon" do
      let(:button) { described_class.new(icon: "heart") }

      before do
        render_inline(button)
      end

      it "renders the icon" do
        expect(page).to have_css "button svg"
      end

      it "skips Iconable's root layout classes (DaisyUI's .btn lays out the icon)" do
        expect(page).not_to have_css 'button.where\\:inline-flex'
      end
    end

    describe "with a single icon and skip_styling" do
      let(:button) { described_class.new(icon: "heart", skip_styling: true) }

      before do
        render_inline(button)
      end

      it "keeps Iconable's root layout classes (no .btn class to lay out the icon)" do
        expect(page).not_to have_css "button.btn"
        expect(page).to have_css 'button.where\\:inline-flex.where\\:items-center.where\\:gap-2'
      end
    end

    describe "with left and right icons" do
      let(:button) { described_class.new(title: "Two Icons", left_icon: "heart", right_icon: "plus") }

      before do
        render_inline(button)
      end

      it "renders both icons" do
        expect(page).to have_css "button svg", count: 2
      end

      it "renders the title between icons" do
        expect(page).to have_button "Two Icons"
      end
    end
  end

  context "with href" do
    let(:button) { described_class.new(href: "/some/path") }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "renders an anchor tag" do
        expect(page).to have_css "a.btn"
      end

      it "includes the href attribute" do
        expect(page).to have_link href: "/some/path"
      end
    end
  end

  context "with Stimulus action" do
    let(:button) { described_class.new(action: "click->test#action") }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "includes the data-action attribute" do
        expect(page).to have_css "button[data-action='click->test#action']"
      end
    end
  end

  context "with both title and action parameters" do
    let(:button) { described_class.new("Click Me", action: "click->test#action") }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "uses first parameter as title" do
        expect(page).to have_button "Click Me"
      end

      it "includes the action attribute" do
        expect(page).to have_css "button[data-action='click->test#action']"
      end
    end
  end

  context "with custom CSS classes" do
    let(:button) { described_class.new(css: "btn-primary btn-lg") }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "includes the custom classes" do
        expect(page).to have_css "button.btn.btn-primary.btn-lg"
      end
    end
  end

  context "with custom HTML attributes" do
    let(:button) { described_class.new(html: { disabled: true, "data-test": "value" }) }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "includes the custom attributes" do
        expect(page).to have_css "button[disabled][data-test='value']"
      end
    end
  end

  context "with tooltip" do
    let(:button) { described_class.new(tip: "Helpful tip") }

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "includes the tooltip attribute" do
        expect(page).to have_css "button[data-tip='Helpful tip']"
      end
    end
  end

  context "with turbo options" do
    let(:button) do
      described_class.new(
        href: "/things/1",
        turbo_frame: "modal",
        turbo_method: :delete,
        turbo_confirm: "Are you sure?"
      )
    end

    before do
      render_inline(button)
    end

    describe "rendering" do
      it "includes the turbo data attributes on the link" do
        expect(page).to have_css "a[href='/things/1'][data-turbo-frame='modal']" \
                                 "[data-turbo-method='delete'][data-turbo-confirm='Are you sure?']"
      end
    end
  end
end
