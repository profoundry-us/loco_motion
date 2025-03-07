require "rails_helper"

RSpec.describe Daisy::DataInput::LabelComponent, type: :component do
  it "renders a label with the correct 'for' attribute" do
    render_inline(described_class.new(for: "input_id"))
    
    expect(page).to have_css("label.label[for='input_id']")
  end
  
  it "renders a label with text from the title option" do
    render_inline(described_class.new(for: "input_id", title: "My Label"))
    
    expect(page).to have_css("label.label[for='input_id'] span.label-text", text: "My Label")
  end
  
  it "renders a label with content from the block" do
    render_inline(described_class.new(for: "input_id")) { "My Label" }
    
    expect(page).to have_css("label.label[for='input_id']", text: "My Label")
  end
  
  it "prioritizes the block content over the title option" do
    render_inline(described_class.new(for: "input_id", title: "Option Text")) { "Block Text" }
    
    expect(page).to have_css("label.label[for='input_id']", text: "Block Text")
    expect(page).not_to have_css("span.label-text", text: "Option Text")
  end
end
