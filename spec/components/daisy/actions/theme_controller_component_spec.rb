require "rails_helper"

RSpec.describe Daisy::Actions::ThemeControllerComponent, type: :component do
  let(:controller) { described_class.new }

  before do
    render_inline(controller)
  end

  describe "rendering" do
    it "renders a flex container" do
      expect(page).to have_css ".flex.flex-col.lg\\:flex-row"
    end

    it "includes gap and alignment classes" do
      expect(page).to have_css ".gap-4.items-center"
    end

    it "renders theme labels" do
      described_class::SOME_THEMES.each do |theme|
        expect(page).to have_css ".label-text", text: theme.titleize
      end
    end

    it "renders radio inputs for themes" do
      expect(page).to have_css "input[type='radio'].theme-controller", count: described_class::SOME_THEMES.length
    end

    it "checks the light theme by default" do
      expect(page).to have_css "input[type='radio'][value='light'][checked]"
    end
  end
end
