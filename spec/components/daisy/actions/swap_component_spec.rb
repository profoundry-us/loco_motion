require "rails_helper"

RSpec.describe Daisy::Actions::SwapComponent, type: :component do
  context "with no options" do
    let(:swap) { described_class.new }

    before do
      render_inline(swap)
    end

    describe "setup" do
      it "sets checked to false by default" do
        expect(swap.instance_variable_get(:@checked)).to eq(false)
      end

      it "has no simple_on text" do
        expect(swap.simple_on).to be_nil
      end

      it "has no simple_off text" do
        expect(swap.simple_off).to be_nil
      end
    end

    describe "rendering" do
      it "renders a label with swap class" do
        expect(page).to have_css "label.swap"
      end

      it "renders an unchecked checkbox" do
        expect(page).to have_css "input[type='checkbox']:not([checked])"
      end

      it "does not add swap-on class when no on content is provided" do
        expect(page).not_to have_css ".swap-on"
      end

      it "does not add swap-off class when no off content is provided" do
        expect(page).not_to have_css ".swap-off"
      end
    end
  end

  context "with simple text options" do
    let(:swap) { described_class.new(on: "✅ On", off: "❌ Off", checked: true) }

    before do
      render_inline(swap)
    end

    describe "setup" do
      it "sets the simple_on text" do
        expect(swap.simple_on).to eq("✅ On")
      end

      it "sets the simple_off text" do
        expect(swap.simple_off).to eq("❌ Off")
      end

      it "sets checked to true" do
        expect(swap.instance_variable_get(:@checked)).to eq(true)
      end
    end

    describe "rendering" do
      it "renders a checked checkbox" do
        expect(page).to have_css "input[type='checkbox'][checked]"
      end

      it "renders the on text" do
        expect(page).to have_content "✅ On"
      end

      it "renders the off text" do
        expect(page).to have_content "❌ Off"
      end
    end
  end

  context "with custom content" do
    let(:swap) { described_class.new }

    before do
      render_inline(swap) do |s|
        s.with_on do
          content_tag(:div, "Custom On", class: "custom-on")
        end
        s.with_off do
          content_tag(:div, "Custom Off", class: "custom-off")
        end
        s.with_indeterminate do
          content_tag(:div, "Loading...", class: "custom-indeterminate")
        end
      end
    end

    describe "rendering" do
      it "renders custom on content" do
        expect(page).to have_css ".custom-on", text: "Custom On"
      end

      it "renders custom off content" do
        expect(page).to have_css ".custom-off", text: "Custom Off"
      end

      it "renders custom indeterminate content" do
        expect(page).to have_css ".custom-indeterminate", text: "Loading..."
      end
    end
  end
end
