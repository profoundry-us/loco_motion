# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocCodeTabComponent, type: :component do
  it "renders the content in a highlighted code block inside a lifted tab" do
    render_inline(described_class.new) { "= daisy_button" }

    expect(page).to have_css(".tabs.tabs-lift")
    expect(page).to have_css(".tab-content pre code", text: "= daisy_button")
    expect(page).to have_css("code.hljs[data-controller='highlight-code']")
  end

  it "titles the tab 'Code' by default" do
    render_inline(described_class.new) { "some code" }

    expect(page).to have_css("a.tab", text: "Code")
  end

  it "accepts a custom tab title" do
    render_inline(described_class.new(title: "app/views/home.html.haml")) do
      "some code"
    end

    expect(page).to have_css("a.tab", text: "app/views/home.html.haml")
  end

  it "highlights as HAML by default" do
    render_inline(described_class.new) { "some code" }

    expect(page).to have_css("code.language-haml")
  end

  it "accepts a language option" do
    render_inline(described_class.new(language: "ruby")) { "puts 1" }

    expect(page).to have_css("code.language-ruby")
    expect(page).not_to have_css("code.language-haml")
  end

  it "applies tabs_css to the tab itself" do
    render_inline(described_class.new(tabs_css: "w-32")) { "some code" }

    expect(page).to have_css("a.tab.w-32")
  end
end
