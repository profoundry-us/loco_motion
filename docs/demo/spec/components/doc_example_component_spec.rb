# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocExampleComponent, type: :component do
  # The component locates its calling view file (via `caller_locations`) and
  # re-reads it to display the example's own source in the Code tab. Specs
  # can't control `caller_locations`, so we point the component at a fake
  # source file and stub the file read.
  let(:fake_path) { "/fake/views/examples/buttons.html.haml" }

  let(:fake_source) do
    <<~HAML
      %h1 Buttons
        = doc_example(title: "Basic Button") do |doc|
          - doc.with_description do
            %p This paragraph should not appear in the code sample.
          = daisy_button(title: "Click Me")
            %span Nested Line
      %p Trailing content outside the example.
    HAML
  end

  def render_example(source: fake_source, line: 2, **options, &block)
    component = described_class.new(**options)
    component.instance_variable_set(:@calling_file, fake_path)
    component.instance_variable_set(:@line_number, line.to_s)

    allow(File).to receive(:readlines).and_call_original
    allow(File).to receive(:readlines).with(fake_path).and_return(source.lines)

    render_inline(component, &block || proc { "Example preview" })
  end

  it "renders a Preview tab and a Code tab" do
    render_example

    expect(page).to have_css("a.tab", text: "Preview")
    expect(page).to have_css("a.tab", text: "Code")
  end

  it "shows the block content in the preview pane" do
    render_example

    expect(page).to have_css(
      "[data-doc-example-target='preview']", text: "Example preview"
    )
  end

  it "extracts the calling example's source for the code sample" do
    render_example

    code = page.find("pre code").text
    expect(code).to include('= daisy_button(title: "Click Me")')
    expect(code).to include("%span Nested Line")
  end

  it "omits the doc_example wrapper and description block from the code" do
    render_example

    code = page.find("pre code").text
    expect(code).not_to include("doc_example")
    expect(code).not_to include("with_description")
    expect(code).not_to include("should not appear")
  end

  it "stops extracting at the end of the example's indentation" do
    render_example

    expect(page.find("pre code").text).not_to include("Trailing content")
  end

  it "dedents the extracted source but keeps relative indentation" do
    render_example

    lines = page.find("pre code").text.split("\n")
    button_indent = lines.find { |l| l.include?("daisy_button") }[/\A */].length
    nested_indent = lines.find { |l| l.include?("%span") }[/\A */].length

    expect(nested_indent - button_indent).to eq(2)
  end

  it "renders the title as an anchored heading" do
    render_example(title: "Basic Button")

    expect(page).to have_css("h2#basic-button", text: "Basic Button")
  end

  it "renders no heading without a title" do
    render_example

    expect(page).not_to have_css("h2")
  end

  it "renders the description slot with prose styling" do
    render_example do |doc|
      doc.with_description { "Extra context about the example." }
      "Example preview"
    end

    expect(page).to have_css(".prose", text: "Extra context about the example.")
  end

  it "omits the Reset tab by default" do
    render_example

    expect(page).not_to have_css("a.tab", text: "Reset")
  end

  it "renders a Reset tab when allow_reset is set" do
    render_example(allow_reset: true)

    expect(page).to have_css("a.tab", text: "Reset")
  end

  it "wires up the doc-example and active-tab controllers" do
    render_example

    expect(page).to have_css(
      "[data-controller~='doc-example'][data-controller~='active-tab']"
    )
  end
end
