# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocFooterButtonsComponent, type: :component do
  # The component derives previous/next from the sorted view-file list of the
  # section, so we stub the directory listing to keep the spec stable as real
  # pages are added, removed, or reordered. The list is intentionally returned
  # unsorted and includes a partial that must be ignored.
  let(:guide_files) do
    [
      "app/views/guides/02_haml.html.haml",
      "app/views/guides/_wip_warning.html.haml",
      "app/views/guides/01_getting_started.html.haml",
      "app/views/guides/03_deploying.html.haml"
    ].map { |path| Rails.root.join(path).to_s }
  end

  before do
    allow(Dir).to receive(:glob).and_call_original
    allow(Dir).to receive(:glob)
      .with(Rails.root.join("app/views/guides/*.html.*"))
      .and_return(guide_files)
  end

  it "links to the previous and next pages of the section" do
    render_inline(described_class.new(current_id: "02_haml"))

    expect(page).to have_css(
      "a[href='/guides/getting_started']", text: "Previous"
    )
    expect(page).to have_css(
      "a[href='/guides/getting_started']", text: "Getting Started"
    )
    expect(page).to have_css("a[href='/guides/deploying']", text: "Next")
    expect(page).to have_css("a[href='/guides/deploying']", text: "Deploying")
  end

  it "also matches the current page by its prefix-less slug" do
    render_inline(described_class.new(current_id: "haml"))

    expect(page).to have_css("a[href='/guides/getting_started']")
    expect(page).to have_css("a[href='/guides/deploying']")
  end

  it "renders no Previous link on the first page" do
    render_inline(described_class.new(current_id: "01_getting_started"))

    expect(page).not_to have_text("Previous")
    expect(page).to have_css("a[href='/guides/haml']", text: "Next")
  end

  it "renders no Next link on the last page, ignoring partials" do
    render_inline(described_class.new(current_id: "03_deploying"))

    expect(page).not_to have_text("Next")
    expect(page).to have_css("a[href='/guides/haml']", text: "Previous")
  end

  it "renders neither link when the current page is unknown" do
    render_inline(described_class.new(current_id: "not_a_page"))

    expect(page).not_to have_text("Previous")
    expect(page).not_to have_text("Next")
  end

  it "applies the section's title overrides" do
    render_inline(described_class.new(current_id: "01_getting_started"))

    expect(page).to have_css("a[href='/guides/haml']", text: "HAML")
  end

  it "builds doc paths when the section is docs" do
    doc_files = [
      "app/views/docs/01_introduction.html.haml",
      "app/views/docs/02_components.html.haml"
    ].map { |path| Rails.root.join(path).to_s }

    allow(Dir).to receive(:glob)
      .with(Rails.root.join("app/views/docs/*.html.*"))
      .and_return(doc_files)

    render_inline(
      described_class.new(current_id: "01_introduction", section: "docs")
    )

    expect(page).to have_css("a[href='/docs/components']", text: "Components")
  end
end
