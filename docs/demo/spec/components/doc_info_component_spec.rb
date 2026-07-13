# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocInfoComponent, type: :component do
  it "renders the content in a callout linking to the given url" do
    render_inline(described_class.new(url: "https://haml.info")) do
      "HAML is a templating engine."
    end

    expect(page).to have_css("a[href='https://haml.info'][target='_blank']")
    expect(page).to have_text("HAML is a templating engine.")
  end

  it "links to '#' when no url is given" do
    render_inline(described_class.new) { "Some info." }

    expect(page).to have_css("a[href='#']")
  end

  it "renders an icon box with the information-circle icon by default" do
    render_inline(described_class.new) { "Some info." }

    expect(page).to have_css(".bg-base-100 svg")
    expect(page).not_to have_css("img")
  end

  it "applies custom CSS to the icon" do
    render_inline(described_class.new(icon_css: "text-rose-500")) do
      "Some info."
    end

    expect(page).to have_css("svg.text-rose-500")
  end

  it "renders an image instead of the icon box when image_path is given" do
    render_inline(
      described_class.new(image_path: "/images/haml.png", image_alt: "HAML")
    ) { "Some info." }

    expect(page).to have_css("img[src='/images/haml.png'][alt='HAML']")
    expect(page).not_to have_css("svg")
  end
end
