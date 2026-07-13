# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocTitleComponent, type: :component do
  it "renders the title as an h1" do
    render_inline(described_class.new(title: "Buttons")) { "All about it." }

    expect(page).to have_css("h1.text-2xl.font-bold", text: "Buttons")
  end

  it "renders the description content with prose styling" do
    render_inline(described_class.new(title: "Buttons")) { "All about it." }

    expect(page).to have_css(".prose", text: "All about it.")
  end

  it "wires up the doc-title controller" do
    render_inline(described_class.new(title: "Buttons")) { "All about it." }

    expect(page).to have_css("[data-controller~='doc-title']")
  end

  it "renders no API button without a comp option" do
    render_inline(described_class.new(title: "Introduction")) { "Welcome." }

    expect(page).not_to have_link("API Docs")
  end

  it "renders a default API Docs button linking to the component's API page" do
    render_inline(described_class.new(title: "Buttons", comp: "button")) do
      "All about it."
    end

    api_href = "#{Rails.configuration.api_docs_host}/Button.html"
    expect(page).to have_link("API Docs", href: api_href)
  end

  it "camelizes multi-word comp names in the API link" do
    render_inline(
      described_class.new(title: "Theme Controller", comp: "theme_controller")
    ) { "All about it." }

    api_href = "#{Rails.configuration.api_docs_host}/ThemeController.html"
    expect(page).to have_link("API Docs", href: api_href)
  end

  it "allows replacing the default API button via the api_button slot" do
    render_inline(described_class.new(title: "Buttons", comp: "button")) do |c|
      c.with_api_button(title: "Source", href: "https://example.com/source")
    end

    expect(page).to have_link("Source", href: "https://example.com/source")
    expect(page).not_to have_link("API Docs")
  end
end
