require "rails_helper"

RSpec.describe LocoMotion::Buttons::FabComponent, type: :component do
  it "renders component" do
    output = render_inline(described_class.new(css: "new_css")) do |fab|
      # Nothing here yet, but component slots / etc would go in here
    end

    puts " *** output: \n\n#{output.to_xhtml}\n\n"

    expect(page).to have_css "button.new_css"
    # expect(page).to have_text "Hello, World!"
  end
end
