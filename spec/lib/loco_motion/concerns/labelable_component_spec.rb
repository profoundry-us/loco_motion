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
end
