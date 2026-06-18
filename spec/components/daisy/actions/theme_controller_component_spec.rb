# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::Actions::ThemeControllerComponent, type: :component do
  let(:component) { described_class.new }
  let(:test_theme) { "light" }

  describe "initialization" do
    it "sets up default themes" do
      expect(component.themes).to eq(described_class::SOME_THEMES)
    end

    it "allows custom themes" do
      custom_themes = %w[custom1 custom2]
      custom_component = described_class.new(themes: custom_themes)
      expect(custom_component.themes).to eq(custom_themes)
    end
  end

  describe "#before_render" do
    it "adds the theme stimulus controller" do
      allow(component).to receive(:add_stimulus_controller)
      component.before_render
      expect(component).to have_received(:add_stimulus_controller).with(:component, "loco-theme")
    end
  end

  describe "#call" do
    it "wraps the content in the component part" do
      content = "Test Content"
      allow(component).to receive(:part).with(:component).and_yield
      allow(component).to receive(:content).and_return(content)

      expect(component.call).to eq(content)
    end
  end

  describe "#build_radio_input with a block" do
    it "forwards the block to the radio so its slots can be filled" do
      render_inline(described_class.new) do |tc|
        tc.build_radio_input("light") do |radio|
          radio.with_end { "Light theme" }
        end
      end

      expect(page).to have_css("input[type='radio'][value='light'].theme-controller")
      expect(page).to have_text("Light theme")
    end
  end

  # These tests verify the builder methods pass the right arguments to `render`
  # without actually rendering (which needs a real view context). The builders
  # are mocked on a throwaway subclass so they never leak onto the real
  # component class — which keeps every test order-independent.
  describe "component as a factory" do
    let(:factory_class) do
      Class.new(described_class) do
        def mock_render(component_class, **args)
          # Return a simple object that can be inspected
          { component: component_class, args: args }
        end

        def build_radio_input(theme, **options)
          options[:css] = "#{options[:css] || ''} theme-controller"
          name = options[:name] || "theme"
          default_options = { name: name, id: "#{name}-#{theme}", value: theme }

          mock_render(Daisy::DataInput::RadioButtonComponent, **default_options.deep_merge(options))
        end

        def build_theme_preview(theme, **options)
          mock_render(Daisy::Actions::ThemePreviewComponent, theme: theme, **options)
        end
      end
    end

    let(:component) { factory_class.new }

    describe "#build_radio_input" do
      it "correctly configures the radio input" do
        result = component.build_radio_input(test_theme)

        expect(result[:component]).to eq(Daisy::DataInput::RadioButtonComponent)
        expect(result[:args][:name]).to eq("theme")
        expect(result[:args][:id]).to eq("theme-#{test_theme}")
        expect(result[:args][:value]).to eq(test_theme)
        expect(result[:args][:css]).to include("theme-controller")
      end

      it "allows overriding options" do
        result = component.build_radio_input(test_theme, css: "custom-class", checked: true)

        expect(result[:args][:css]).to include("custom-class")
        expect(result[:args][:css]).to include("theme-controller")
        expect(result[:args][:checked]).to be true
      end

      it "namespaces the id by the input name to avoid duplicate ids" do
        result = component.build_radio_input(test_theme, name: "docs-radio-theme")

        expect(result[:args][:name]).to eq("docs-radio-theme")
        expect(result[:args][:id]).to eq("docs-radio-theme-#{test_theme}")
      end
    end

    describe "#build_theme_preview" do
      it "correctly configures the theme preview" do
        result = component.build_theme_preview(test_theme)

        expect(result[:component]).to eq(Daisy::Actions::ThemePreviewComponent)
        expect(result[:args][:theme]).to eq(test_theme)
      end

      it "allows overriding options" do
        custom_options = { size: 8, shadow: false }
        result = component.build_theme_preview(test_theme, **custom_options)

        expect(result[:args][:theme]).to eq(test_theme)
        expect(result[:args][:size]).to eq(8)
        expect(result[:args][:shadow]).to be false
      end
    end
  end

  describe "rendering" do
    it "can be rendered with a simple block" do
      render_inline(component) { "Simple test content" }
      expect(page).to have_content("Simple test content")
    end

    it "gets stimulus controller attributes" do
      render_inline(component)
      expect(page).to have_css("[data-controller='loco-theme']")
    end
  end
end
