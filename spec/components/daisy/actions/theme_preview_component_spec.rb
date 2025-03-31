require "rails_helper"

RSpec.describe Daisy::Actions::ThemePreviewComponent, type: :component do
  let(:theme) { "light" }
  let(:component) { described_class.new(theme) }

  describe "initialization" do
    it "accepts theme as a positional argument" do
      component = described_class.new("dark")
      expect(component.instance_variable_get(:@theme)).to eq("dark")
    end

    it "accepts theme as a keyword argument" do
      component = described_class.new(theme: "cyberpunk")
      expect(component.instance_variable_get(:@theme)).to eq("cyberpunk")
    end

    it "uses keyword argument over positional argument when both are provided" do
      component = described_class.new("wireframe", theme: "synthwave")
      expect(component.instance_variable_get(:@theme)).to eq("synthwave")
    end
  end

  describe "#setup_component" do
    it "adds the correct CSS classes to the component" do
      allow(component).to receive(:add_css)
      allow(component).to receive(:add_html)

      component.setup_component

      expected_classes = "where:size-4 where:grid where:grid-cols-2 where:place-items-center " \
                       "where:shrink-0 where:rounded-md where:bg-base-100 where:shadow-sm"

      expect(component).to have_received(:add_css).with(:component, expected_classes)
    end

    it "sets the data-theme attribute" do
      allow(component).to receive(:add_css)
      allow(component).to receive(:add_html)

      component.setup_component

      expect(component).to have_received(:add_html).with(:component, { "data-theme": theme })
    end
  end

  describe "#setup_dots" do
    it "adds the correct CSS classes to all dots" do
      allow(component).to receive(:add_css)

      component.setup_dots

      [:dot_base, :dot_primary, :dot_secondary, :dot_accent].each do |dot|
        base_class = dot == :dot_base ? "where:bg-base-content" : "where:bg-#{dot.to_s.sub('dot_', '')}"
        expected_classes = "#{base_class} where:size-1 where:rounded-full"
        expect(component).to have_received(:add_css).with(dot, expected_classes)
      end
    end
  end

  describe "rendering" do
    before do
      render_inline(component)
    end

    it "renders a container with the theme data attribute" do
      expect(page).to have_css("[data-theme='#{theme}']")
    end

    it "renders with the correct layout classes" do
      expect(page).to have_css("[class*='where:grid'][class*='where:grid-cols-2']")
    end

    it "renders four color dots" do
      # Each dot should have the rounded-full class
      expect(page).to have_css("[class*='where:rounded-full']", count: 4)
    end

    it "renders a base content dot" do
      expect(page).to have_css("[class*='where:bg-base-content']")
    end

    it "renders a primary color dot" do
      expect(page).to have_css("[class*='where:bg-primary']")
    end

    it "renders a secondary color dot" do
      expect(page).to have_css("[class*='where:bg-secondary']")
    end

    it "renders an accent color dot" do
      expect(page).to have_css("[class*='where:bg-accent']")
    end
  end

  describe "customization" do
    context "with custom CSS classes" do
      let(:custom_css) { "custom-class1 custom-class2" }

      it "applies custom CSS classes" do
        render_inline(described_class.new(theme, css: custom_css))

        # Instead of checking internal methods, check the rendered output
        expect(page.native.to_html).to include(custom_css)
      end
    end

    context "with different themes" do
      it "applies the theme data attribute correctly" do
        themes = ["dark", "cyberpunk", "forest"]

        themes.each do |theme_name|
          themed_component = described_class.new(theme_name)
          render_inline(themed_component)
          expect(page).to have_css("[data-theme='#{theme_name}']")
        end
      end
    end
  end
end
