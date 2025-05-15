RSpec.describe Daisy::DataInput::CallyInputComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new)
    expect(page).to have_css("input.input")
    expect(page).to have_css("[popover='auto'] calendar-date")
  end
end
