# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocCodeComponent, type: :component do
  it "renders the content inside a pre > code block" do
    render_inline(described_class.new) { "= daisy_button(title: :hi)" }

    expect(page).to have_css("pre code", text: "= daisy_button(title: :hi)")
  end

  it "strips surrounding whitespace from the content" do
    render_inline(described_class.new) { "\n  = daisy_button\n\n" }

    expect(page.find("code").text).to eq("= daisy_button")
  end

  it "highlights as HAML by default" do
    render_inline(described_class.new) { "some code" }

    expect(page).to have_css("code.hljs.language-haml")
  end

  it "wires up the highlight-code controller on the code element" do
    render_inline(described_class.new) { "some code" }

    expect(page).to have_css("code[data-controller='highlight-code']")
  end

  it "accepts a language option" do
    render_inline(described_class.new(language: "ruby")) { "puts 1" }

    expect(page).to have_css("code.language-ruby")
    expect(page).not_to have_css("code.language-haml")
  end

  it "lets long lines scroll instead of wrapping" do
    render_inline(described_class.new) { "some code" }

    expect(page).to have_css("pre.p-0\\!.overflow-x-auto")
  end

  it "accepts additional CSS on the wrapper" do
    render_inline(described_class.new(css: "mb-8")) { "some code" }

    expect(page).to have_css("div.mb-8 > pre > code")
  end
end
