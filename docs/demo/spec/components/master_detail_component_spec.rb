# frozen_string_literal: true

require "rails_helper"

RSpec.describe MasterDetailComponent, type: :component do
  def render_two_records
    render_inline(described_class.new) do |layout|
      layout.with_record(title: "First") { "First body" }
      layout.with_record(title: "Second") { "Second body" }
    end
  end

  it "renders a master button per record" do
    render_two_records

    expect(page).to have_css(
      "button[data-master-detail-target='tab']", count: 2
    )
    expect(page).to have_button("First")
    expect(page).to have_button("Second")
  end

  it "wires each button to select its record by index" do
    render_two_records

    expect(page).to have_css(
      "button[data-action='click->master-detail#select']" \
      "[data-master-detail-index-param='0']",
      text: "First"
    )
    expect(page).to have_css(
      "button[data-master-detail-index-param='1']", text: "Second"
    )
  end

  it "renders a detail pane per record with only the first visible" do
    render_two_records

    panes = page.all("[data-master-detail-target='pane']")
    expect(panes.length).to eq(2)
    expect(panes[0][:class].to_s).not_to include("hidden")
    expect(panes[1][:class].to_s).to include("hidden")
  end

  it "renders each record's body in its pane" do
    render_two_records

    expect(page).to have_css(
      "[data-master-detail-target='pane']", text: "First body"
    )
    expect(page).to have_css(
      "[data-master-detail-target='pane']", text: "Second body"
    )
  end

  it "wires up the master-detail controller on a bordered layout" do
    render_two_records

    expect(page).to have_css(
      "[data-controller~='master-detail'].rounded-box.border"
    )
  end
end
