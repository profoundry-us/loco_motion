# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::DataInput::RatingComponent, type: :component do
  it "renders a rating component with default options" do
    render_inline(described_class.new(name: "rating"))

    expect(page).to have_css("div.rating")
    expect(page).to have_css("input[type='radio'][class='hidden']", count: 1)
    expect(page).to have_css("input[type='radio'][class!='hidden']", count: 5)
    expect(page).to have_css("input[class*='mask']", count: 5)
    expect(page).to have_css("input[class*='mask-star']", count: 5)
  end

  it "renders with specified number of stars" do
    render_inline(described_class.new(name: "rating", max: 3))

    expect(page).to have_css("input[type='radio'][class='hidden']", count: 1)
    expect(page).to have_css("input[type='radio'][class!='hidden']", count: 3)
  end

  it "renders with a selected value" do
    render_inline(described_class.new(name: "rating", value: 3))

    expect(page).to have_css("input[checked]", count: 1)
    expect(page).to have_css("input[value='3'][checked]")
  end

  it "renders in read-only mode" do
    render_inline(described_class.new(name: "rating", value: 3, disabled: true))

    expect(page).to have_css("div.rating")
    expect(page).to have_css("input[type='radio'][class='hidden']", count: 1)
    expect(page).to have_css("input[type='radio'][class!='hidden'][disabled]", count: 5)
    expect(page).to have_css("input[value='3'][checked]")
  end

  it "handles required attribute" do
    render_inline(described_class.new(name: "rating", required: true))

    # Only the first radio should be required to avoid validation issues
    expect(page).to have_css("input[required]", count: 1)
    expect(page).to have_css("input[value='1'][required]")
  end

  it "sets proper aria labels" do
    render_inline(described_class.new(name: "rating", max: 2))

    expect(page).to have_css("input[aria-label='1 star']")
    expect(page).to have_css("input[aria-label='2 star']")
  end
end
