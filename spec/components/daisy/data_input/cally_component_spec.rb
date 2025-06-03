# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::DataInput::CallyComponent, type: :component do
  context "basic rendering" do
    let(:component) { described_class.new }

    before do
      render_inline(component)
    end

    it "renders a calendar component" do
      expect(page).to have_css("calendar-date.cally")
    end

    it "renders default icons" do
      expect(page).to have_css("[slot='previous']")
      expect(page).to have_css("[slot='next']")
    end
  end

  context "with range modifier" do
    let(:component) { described_class.new(modifiers: [:range]) }

    before do
      render_inline(component)
    end

    it "renders a range calendar" do
      expect(page).to have_css("calendar-range.cally")
    end
  end

  context "with configuration options" do
    let(:component) do
      described_class.new(
        id: "test-calendar",
        value: "2025-05-15",
        min: "2025-01-01",
        max: "2025-12-31",
        today: "2025-05-15",
        months: 2
      )
    end

    before do
      render_inline(component)
    end

    it "sets the id attribute" do
      expect(page).to have_css("calendar-date[id='test-calendar']")
    end

    it "sets the value attribute" do
      expect(page).to have_css("calendar-date[value='2025-05-15']")
    end

    it "sets the min attribute" do
      expect(page).to have_css("calendar-date[min='2025-01-01']")
    end

    it "sets the max attribute" do
      expect(page).to have_css("calendar-date[max='2025-12-31']")
    end

    it "sets the today attribute" do
      expect(page).to have_css("calendar-date[today='2025-05-15']")
    end

    it "sets the months attribute" do
      expect(page).to have_css("calendar-date[months='2']")
    end
  end

  context "with change option" do
    let(:component) do
      described_class.new(change: "target-input")
    end

    before do
      render_inline(component)
    end

    it "sets the onchange handler for the input target" do
      expect(page.native.to_html).to include("onchange=\"document.getElementById('target-input').value = this.value\"")
    end
  end

  context "with update option" do
    let(:component) do
      described_class.new(update: "target-display")
    end

    before do
      render_inline(component)
    end

    it "sets the onchange handler for the display target" do
      expect(page.native.to_html).to include("onchange=\"document.getElementById('target-display').innerHTML = this.value\"")
    end
  end

  context "with custom icons" do
    let(:component) { described_class.new }

    before do
      render_inline(component) do |c|
        c.with_previous_icon(icon: "arrow-left")
        c.with_next_icon(icon: "arrow-right")
      end
    end

    it "renders custom previous icon" do
      expect(page).to have_css("svg[slot='previous']")
    end

    it "renders custom next icon" do
      expect(page).to have_css("svg[slot='next']")
    end
  end

  context "with custom months" do
    it "allows adding multiple months" do
      component = described_class.new

      # Add two months
      component.with_month(offset: 0)
      component.with_month(offset: 1)

      # Verify two months were added
      expect(component.months.size).to eq(2)
    end

    it "creates month components with proper initialization" do
      # Test the MonthComponent directly
      month = Daisy::DataInput::CallyComponent::MonthComponent.new(offset: 1)
      expect(month.instance_variable_get(:@offset)).to eq(1)
    end
  end

  context "month_options method" do
    let(:component) { described_class.new }

    it "returns empty hash for index 0" do
      expect(component.month_options(0)).to eq({})
    end

    it "returns hash with offset for index > 0" do
      expect(component.month_options(1)).to eq({ offset: 1 })
      expect(component.month_options(2)).to eq({ offset: 2 })
    end
  end

  context "with MonthComponent" do
    let(:month_component) { Daisy::DataInput::CallyComponent::MonthComponent.new(offset: 2) }

    before do
      render_inline(month_component)
    end

    it "renders a calendar-month tag" do
      expect(page).to have_css("calendar-month[offset='2']")
    end
  end

  context "with PreviousIcon and NextIcon" do
    let(:previous_icon) { Daisy::DataInput::CallyComponent::PreviousIcon.new(icon: "chevron-left") }
    let(:next_icon) { Daisy::DataInput::CallyComponent::NextIcon.new(icon: "chevron-right") }

    it "sets slot attribute for PreviousIcon" do
      render_inline(previous_icon)
      expect(page).to have_css("[slot='previous']")
    end

    it "sets slot attribute for NextIcon" do
      render_inline(next_icon)
      expect(page).to have_css("[slot='next']")
    end
  end

  context "default icons methods" do
    let(:component) { described_class.new }

    it "default_previous_icon returns PreviousIcon with chevron-left" do
      icon = component.default_previous_icon
      expect(icon).to be_a(Daisy::DataInput::CallyComponent::PreviousIcon)
      expect(icon.instance_variable_get(:@icon)).to eq("chevron-left")
    end

    it "default_next_icon returns NextIcon with chevron-right" do
      icon = component.default_next_icon
      expect(icon).to be_a(Daisy::DataInput::CallyComponent::NextIcon)
      expect(icon.instance_variable_get(:@icon)).to eq("chevron-right")
    end
  end
end
