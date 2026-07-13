# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocChecklistComponent, type: :component do
  it "renders a named checkbox per item" do
    render_inline(described_class.new) do |list|
      list.with_item(name: "first_step") { "Do the first thing." }
      list.with_item(name: "second_step") { "Do the second thing." }
    end

    expect(page).to have_css("input[type='checkbox']", count: 2)
    expect(page).to have_css("input[name='first_step'][id='first_step']")
    expect(page).to have_css("input[name='second_step'][id='second_step']")
  end

  it "allows overriding the id independently of the name" do
    render_inline(described_class.new) do |list|
      list.with_item(name: "step", id: "custom_id") { "Do the thing." }
    end

    expect(page).to have_css("input[name='step'][id='custom_id']")
  end

  it "renders item content as Markdown in the checkbox label" do
    render_inline(described_class.new) do |list|
      list.with_item(name: "step") do
        "Run `bin/setup` from the [readme](/docs/install)."
      end
    end

    expect(page).to have_css("label.label p code", text: "bin/setup")
    expect(page).to have_css("label.label p a[href='/docs/install']", text: "readme")
  end

  it "applies the mobile label-wrapping classes to the wrapper" do
    render_inline(described_class.new) do |list|
      list.with_item(name: "step") { "Do the thing." }
    end

    expect(page).to have_css(
      "div.max-w-prose" \
      ".\\[\\&_\\.label\\]\\:items-start" \
      ".\\[\\&_\\.label\\]\\:whitespace-normal" \
      ".\\[\\&_code\\]\\:wrap-anywhere"
    )
  end

  it "accepts additional CSS on the wrapper" do
    render_inline(described_class.new(css: "mt-6")) do |list|
      list.with_item(name: "step") { "Do the thing." }
    end

    expect(page).to have_css("div.max-w-prose.mt-6")
  end
end
