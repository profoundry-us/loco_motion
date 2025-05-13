RSpec.describe Daisy::DataInput::CallyInputComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new)
    expect(page).to have_css(".cally-input")
  end
end
