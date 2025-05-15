# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::DataInput::CallyInputComponent, type: :component do
  # Basic rendering
  context "basic rendering" do
    let(:component) { described_class.new }

    before do
      render_inline(component)
    end

    it "renders the input" do
      expect(page).to have_css("input.input")
    end

    it "renders the calendar in a popover" do
      expect(page).to have_css("[popover='auto'] calendar-date")
    end

    it "includes the stimulus controller" do
      expect(page).to have_css("[data-controller='cally-input']")
    end

    it "sets up data attributes for stimulus targets" do
      expect(page).to have_css("[data-cally-input-target='input']")
      expect(page).to have_css("[data-cally-input-target='calendar']")
      expect(page).to have_css("[data-cally-input-target='popover']")
    end
  end

  # Testing with predefined values
  context "with provided values" do
    let(:custom_id) { "custom-cally-id" }
    let(:date_value) { "2025-05-15" }
    let(:component) { described_class.new(id: custom_id, value: date_value) }

    before do
      render_inline(component)
    end

    it "uses the provided ID" do
      expect(page).to have_css("[id='#{custom_id}']")
    end

    it "sets the value on the input" do
      expect(page).to have_css("input[value='#{date_value}']")
    end

    it "sets the value on the calendar" do
      expect(page).to have_css("calendar-date[value='#{date_value}']")
    end
  end

  # Testing reader methods
  context "component attribute readers" do
    let(:custom_id) { "reader-test-id" }
    let(:date_value) { "2025-12-31" }
    let(:component) { described_class.new(id: custom_id, value: date_value) }

    it "provides access to id" do
      expect(component.id).to eq(custom_id)
    end

    it "provides access to value" do
      expect(component.value).to eq(date_value)
    end

    it "provides access to derived IDs" do
      expect(component.calendar_id).to eq("#{custom_id}-calendar")
      expect(component.input_id).to eq("#{custom_id}-input")
      expect(component.popover_id).to eq("#{custom_id}-popover")
      expect(component.anchor).to eq("#{custom_id}-anchor")
    end
  end

  # Testing default components
  context "default components" do
    let(:component) { described_class.new }

    it "provides a default calendar" do
      expect(component.default_calendar).to be_an_instance_of(Daisy::DataInput::CallyInputComponent::CallyCalendarComponent)
    end

    it "provides a default input" do
      expect(component.default_input).to be_an_instance_of(Daisy::DataInput::CallyInputComponent::CallyTextInputComponent)
    end
  end
end
