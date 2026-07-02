# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocoMotion::Concerns::LabelableComponent, type: :component do
  # daisy_checkbox is the simplest real labelable component, so we exercise
  # the concern through it.
  let(:component_class) { Daisy::DataInput::CheckboxComponent }

  describe "leading / trailing options" do
    it "renders a leading label" do
      render_inline(component_class.new(name: "terms", leading: "Accept:"))

      expect(page).to have_selector("label span", text: "Accept:")
    end

    it "renders a trailing label" do
      render_inline(component_class.new(name: "terms", trailing: "I accept"))

      expect(page).to have_selector("label span", text: "I accept")
    end

    it "styles the labels via leading_css / trailing_css" do
      render_inline(component_class.new(name: "terms", leading: "A", trailing: "B",
                                        leading_css: "font-bold", trailing_css: "italic"))

      expect(page).to have_selector("span.font-bold", text: "A")
      expect(page).to have_selector("span.italic", text: "B")
    end
  end

  describe "leading / trailing slots" do
    it "renders the slots around the input" do
      render_inline(component_class.new(name: "terms")) do |component|
        component.with_leading { "Before" }
        component.with_trailing { "After" }
      end

      expect(page).to have_text("Before")
      expect(page).to have_text("After")
    end
  end

  describe "deprecated start / end API" do
    around do |example|
      # Silence the expected deprecation output while still allowing the
      # behavior assertions to run.
      behavior = described_class::DEPRECATOR.behavior
      described_class::DEPRECATOR.behavior = :silence
      example.run
    ensure
      described_class::DEPRECATOR.behavior = behavior
    end

    it "translates the start: option to leading:" do
      render_inline(component_class.new(name: "terms", start: "Accept:"))

      expect(page).to have_selector("label span", text: "Accept:")
    end

    it "translates the end: option to trailing:" do
      render_inline(component_class.new(name: "terms", end: "I accept"))

      expect(page).to have_selector("label span", text: "I accept")
    end

    it "translates start_css: / end_css: to the renamed parts" do
      render_inline(component_class.new(name: "terms", start: "A", end: "B",
                                        start_css: "font-bold", end_css: "italic"))

      expect(page).to have_selector("span.font-bold", text: "A")
      expect(page).to have_selector("span.italic", text: "B")
    end

    it "supports the with_start / with_end slot aliases" do
      render_inline(component_class.new(name: "terms")) do |component|
        component.with_start { "Before" }
        component.with_end { "After" }
      end

      expect(page).to have_text("Before")
      expect(page).to have_text("After")
    end

    it "warns when a legacy option is used" do
      expect(described_class::DEPRECATOR).to receive(:warn).with(/`end:` option is deprecated/)

      render_inline(component_class.new(name: "terms", end: "I accept"))
    end

    it "warns when a legacy slot writer is used" do
      expect(described_class::DEPRECATOR).to receive(:warn).with(/`with_end` is deprecated/)

      render_inline(component_class.new(name: "terms")) do |component|
        component.with_end { "After" }
      end
    end

    it "prefers the new option when both are provided" do
      render_inline(component_class.new(name: "terms", trailing: "New", end: "Old"))

      expect(page).to have_selector("label span", text: "New")
      expect(page).to have_no_text("Old")
    end
  end
end
